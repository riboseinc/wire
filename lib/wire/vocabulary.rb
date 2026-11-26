# frozen_string_literal: true

module Wire
  # Closed vocabularies loaded from vocabularies/*.yaml.
  # Single source of truth: the YAML files; this class only reads them.
  class Vocabulary
    Record = Struct.new(:name, :values, keyword_init: true)

    def self.load(name, dir: default_dir)
      path = File.join(dir, "#{name}.yaml")
      raise ArgumentError, "unknown vocabulary: #{name}" unless File.exist?(path)

      require "yaml"
      values = YAML.load_file(path).fetch("values")
      Record.new(name: name.to_s, values: values.freeze).freeze
    end

    def self.default_dir =
      File.expand_path("../../vocabularies", __dir__)
  end
end
