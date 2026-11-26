# frozen_string_literal: true

module Wire
  module Publish
    # Consumer-facing media projection: the alt text flattened to a string.
    class MediaAssetSummary < Lutaml::Model::Serializable
      attribute :id, :string
      attribute :href, :string
      attribute :credit, :string
      attribute :alt, :string

      json do
        map :id, to: :id
        map :href, to: :href
        map :credit, to: :credit
        map :alt, to: :alt
      end

      def self.from_asset(asset)
        new(id: asset.id, href: asset.href, credit: asset.credit, alt: asset.altText&.content)
      end
    end

    # index-full.json entry: the news.json projection plus the payload the
    # hub inlines at build time (body rendition, authors, media, dateline).
    class FullEntry < Lutaml::Model::Serializable
      attribute :id, :string
      attribute :version, :integer
      attribute :status, :string
      attribute :headline, :string
      attribute :subheadline, :string
      attribute :language, :string
      attribute :origin_site, :string
      attribute :canonical, :string
      attribute :path, :string
      attribute :published, :date_time
      attribute :subjects, :string, collection: true
      attribute :topics, :string, collection: true
      attribute :body_adoc, :string
      attribute :authors, Models::Author, collection: true
      attribute :media, MediaAssetSummary, collection: true
      attribute :dateline, Models::Dateline

      json do
        map :id, to: :id
        map :version, to: :version
        map :status, to: :status
        map :headline, to: :headline
        map "subheadline", to: :subheadline
        map :language, to: :language
        map "originSite", to: :origin_site
        map :canonical, to: :canonical
        map :path, to: :path
        map :published, to: :published
        map :subjects, to: :subjects
        map :topics, to: :topics
        map "bodyAdoc", to: :body_adoc
        map :authors, to: :authors
        map :media, to: :media
        map :dateline, to: :dateline
      end

      def self.from_item(item, body_adoc)
        entry = IndexEntry.from_item(item)
        new(
          id: entry.id,
          version: entry.version,
          status: entry.status,
          headline: entry.headline,
          subheadline: item.subheadline&.content,
          language: entry.language,
          origin_site: entry.origin_site,
          canonical: entry.canonical,
          path: entry.path,
          published: entry.published,
          subjects: entry.subjects,
          topics: entry.topics,
          body_adoc: body_adoc,
          authors: item.authors,
          media: item.media.map { |asset| MediaAssetSummary.from_asset(asset) },
          dateline: item.dateline
        )
      end
    end

  end
end
