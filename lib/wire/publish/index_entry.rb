# frozen_string_literal: true

module Wire
  module Publish
    # One entry of the news.json index. A projection model -- its
    # serialization is a lutaml-model mapping, like every other model.
    class IndexEntry < Lutaml::Model::Serializable
      attribute :id, :string
      attribute :version, :integer
      attribute :status, :string
      attribute :headline, :string
      attribute :language, :string
      attribute :origin_site, :string
      attribute :canonical, :string
      attribute :path, :string
      attribute :published, :date_time
      attribute :subjects, :string, collection: true
      attribute :topics, :string, collection: true

      json do
        map :id, to: :id
        map :version, to: :version
        map :status, to: :status
        map :headline, to: :headline
        map :language, to: :language
        map "originSite", to: :origin_site
        map :canonical, to: :canonical
        map :path, to: :path
        map :published, to: :published
        map :subjects, to: :subjects
        map :topics, to: :topics
      end

      yaml do
        map :id, to: :id
        map :version, to: :version
        map :status, to: :status
        map :headline, to: :headline
        map :language, to: :language
        map "originSite", to: :origin_site
        map :canonical, to: :canonical
        map :path, to: :path
        map :published, to: :published
        map :subjects, to: :subjects
        map :topics, to: :topics
      end

      def self.from_item(item)
        new(
          id: item.id,
          version: item.version,
          status: item.status,
          headline: item.plain_headline,
          language: item.language,
          origin_site: item.origin.site,
          canonical: item.origin.canonical,
          path: "articles/#{UrnPath.call(item.id)}/#{item.version}/",
          published: item.timestamps&.published,
          subjects: item.subjects,
          topics: item.topics
        )
      end
    end
  end
end
