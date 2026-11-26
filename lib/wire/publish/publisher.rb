# frozen_string_literal: true

require "fileutils"

module Wire
  module Publish
    # Publishes eligible items as static files. The clock is injected
    # (`now:`) so selection is deterministic and testable.
    class Publisher
      Result = Struct.new(:output_dir, :published_ids, :skipped, keyword_init: true)

      attr_reader :output_dir, :now

      def initialize(items_root:, output_dir:, base_url:, now: Time.now)
        @items_root = items_root
        @output_dir = output_dir
        @base_url = base_url
        @now = now
      end

      def call(records)
        eligible = records.select { |record| eligible?(record.item) }
        FileUtils.rm_rf(output_dir)
        FileUtils.mkdir_p(output_dir)
        entries = eligible.map { |record| publish_article(record) }
        write_index(entries)
        write_index_full(entries)
        write_feeds(entries)
        Result.new(output_dir: output_dir,
                   published_ids: eligible.map { |r| r.item.id },
                   skipped: (records - eligible).map { |r| [r.item.id, r.item.status] })
      end

      private

      def eligible?(item)
        item.public? && (item.embargo.nil? || item.embargo <= now)
      end

      def publish_article(record)
        item = record.item
        dir = File.join(output_dir, "articles", UrnPath.call(item.id),
                        item.version.to_s)
        FileUtils.mkdir_p(dir)
        FileUtils.cp(record.envelope_path, File.join(dir, "item.yaml"))
        FileUtils.cp(record.body_path, File.join(dir, "body.adoc"))
        item.media.each do |asset|
          src = record.media_path(asset)
          FileUtils.mkdir_p(File.dirname(File.join(dir, asset.href)))
          FileUtils.cp(src, File.join(dir, asset.href))
        end
        IndexEntry.from_item(item)
      end

      def write_index(entries)
        index = { "generatedAt" => now.iso8601,
                  "articles" => JSON.parse(entries.map(&:to_json).join(",").then { |a| "[#{a}]" }) }
        File.write(File.join(output_dir, "news.json"), JSON.pretty_generate(index))
      end

      # Full index for build-time consumers that inline article payloads
      # (www.ribose.com) instead of reading the per-article files.
      def write_index_full(entries)
        articles = entries.map do |entry|
          item = load_entry_item(entry)
          body = File.read(File.join(output_dir, entry.path, "body.adoc"))
          FullEntry.from_item(item, body).to_json
        end
        index = { "generatedAt" => now.iso8601,
                  "articles" => JSON.parse(articles.join(",").then { |a| "[#{a}]" }) }
        File.write(File.join(output_dir, "index-full.json"), JSON.pretty_generate(index))
      end

      def write_feeds(entries)
        items = entries.map { |entry| load_entry_item(entry) }
        ninjs = { "uri" => @base_url,
                  "items" => JSON.parse("[" + items.map do |item|
                    NinjsItem.from_item(item, @base_url).to_json
                  end.join(",") + "]") }
        File.write(File.join(output_dir, "feed.json"), JSON.pretty_generate(ninjs))
        File.write(File.join(output_dir, "feed.xml"),
                   AtomFeed.render(title: "Ribose News", id: "#{@base_url}/feed.xml",
                                   updated: now.iso8601, entries: entries))
        File.write(File.join(output_dir, "newsml.xml"),
                   NewsmlMessage.render(items: items, generated_at: now))
      end

      def load_entry_item(entry)
        @item_cache ||= {}
        @item_cache[entry.id] ||= Models::NewsItem.from_yaml(
          File.read(File.join(output_dir, entry.path, "item.yaml"))
        )
      end
    end
  end
end
