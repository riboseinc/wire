# frozen_string_literal: true

module Wire
  module Publish
    # ninjs (IPTC News in JSON) projection of a NewsItem, for the
    # machine-readable feed consumed by outside systems.
    class NinjsItem < Lutaml::Model::Serializable
      attribute :uri, :string
      attribute :type, :string
      attribute :headline, :string
      attribute :description, :string
      attribute :language, :string
      attribute :by, :string
      attribute :version, :integer
      attribute :versioncreated, :date_time
      attribute :subjectcodes, :string, collection: true

      json do
        map :uri, to: :uri
        map :type, to: :type
        map :headline, to: :headline
        map :description, to: :description
        map :language, to: :language
        map :by, to: :by
        map :version, to: :version
        map :versioncreated, to: :versioncreated
        map :subjectcodes, to: :subjectcodes
      end

      def self.from_item(item, base_url)
        new(
          uri: item.origin.canonical,
          type: "text",
          headline: item.plain_headline,
          description: item.shortHeadline&.content || item.subheadline&.content || "",
          language: item.language,
          by: item.authors.map(&:name).join(", "),
          version: item.version,
          versioncreated: item.timestamps&.updated || item.timestamps&.created,
          subjectcodes: item.subjects.map { |s| "ribose:#{s}" }
        )
      end
    end
  end
end
