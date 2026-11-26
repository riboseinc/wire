# frozen_string_literal: true

module Wire
  # The sites participating in news sharing (registries/sites.yaml).
  class SitesRegistry
    Site = Struct.new(:id, :name, :url, :type, :news_path, keyword_init: true)

    attr_reader :sites

    def self.load(path: default_path)
      require "yaml"
      sites = YAML.load_file(path).fetch("sites").map do |entry|
        Site.new(id: entry.fetch("id"), name: entry.fetch("name"),
                 url: entry.fetch("url"), type: entry["type"],
                 news_path: entry["news_path"])
      end
      new(sites)
    end

    def self.default_path =
      File.expand_path("../../registries/sites.yaml", __dir__)

    def initialize(sites)
      @sites = sites.freeze
    end

    def ids = sites.map(&:id)

    def find(site_id) = sites.detect { |site| site.id == site_id }
  end
end
