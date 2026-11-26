# frozen_string_literal: true

require "optparse"

module Wire
  # Command-line interface. Commands are registered in COMMANDS; adding
  # one is a new key, not a modified dispatch (OCP).
  class CLI
    COMMANDS = {}

    def self.register(name, &handler)
      COMMANDS[name.to_s] = handler
    end

    register("validate") do |argv|
      options = { items: "items" }
      OptionParser.new { |o| o.on("--items DIR") { |d| options[:items] = d } }.parse(argv)
      loader = ItemLoader.new(root: File.expand_path(options[:items]))
      runner = Validation::Runner.build
      violations = runner.run(loader.records)
      if violations.empty?
        puts "OK: #{loader.records.size} item(s) valid"
      else
        violations.each { |v| puts "#{v.check}: #{v.item_id}: #{v.message}" }
        exit 1
      end
    end

    register("publish") do |argv|
      options = { items: "items", out: "publish", now: Time.now }
      OptionParser.new do |o|
        o.on("--items DIR") { |d| options[:items] = d }
        o.on("--out DIR") { |d| options[:out] = d }
        o.on("--now TIME") { |t| options[:now] = Time.parse(t) }
      end.parse(argv)
      loader = ItemLoader.new(root: File.expand_path(options[:items]))
      runner = Validation::Runner.build
      violations = runner.run(loader.records)
      unless violations.empty?
        violations.each { |v| puts "#{v.check}: #{v.item_id}: #{v.message}" }
        abort "validation failed; nothing published"
      end
      result = Publish::Publisher.new(
        items_root: loader.root,
        output_dir: File.expand_path(options[:out]),
        base_url: "https://news.ribose.com",
        now: options[:now]
      ).call(loader.records)
      puts "published #{result.published_ids.size} item(s) to #{result.output_dir}"
      result.skipped.each { |id, status| puts "skipped #{id} (#{status})" }
    end

    def self.run(argv)
      command = argv.shift
      handler = COMMANDS[command]
      abort "usage: wire {validate|publish} [--items DIR] [--out DIR] [--now TIME]" unless handler

      handler.call(argv)
    end
  end
end
