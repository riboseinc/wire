# frozen_string_literal: true

module Wire
  module Models
    class NewsItem < Lutaml::Model::Serializable
      attribute :id, :string
      attribute :version, :integer
      attribute :status, :string
      attribute :supersedes, :string
      attribute :guid, :string
      attribute :headline, LocalizedString
      attribute :subheadline, LocalizedString
      attribute :shortHeadline, LocalizedString
      attribute :dateline, Dateline
      attribute :embargo, :date_time
      attribute :language, :string
      attribute :editionOf, :string
      attribute :origin, Origin
      attribute :distribution, :string, collection: true
      attribute :subjects, :string, collection: true
      attribute :topics, :string, collection: true
      attribute :authors, Author, collection: true
      attribute :contacts, MediaContact, collection: true
      attribute :media, MediaAsset, collection: true
      attribute :links, RelatedLink, collection: true
      attribute :boilerplate, BoilerplateRef, collection: true
      attribute :rights, Rights
      attribute :timestamps, Timestamps
      attribute :body, BodySource

      yaml do
        map :id, to: :id
        map :version, to: :version
        map :status, to: :status
        map :supersedes, to: :supersedes
        map :guid, to: :guid
        map :headline, to: :headline
        map :subheadline, to: :subheadline
        map "shortHeadline", to: :shortHeadline
        map :dateline, to: :dateline
        map :embargo, to: :embargo
        map :language, to: :language
        map "editionOf", to: :editionOf
        map :origin, to: :origin
        map :distribution, to: :distribution
        map :subjects, to: :subjects
        map :topics, to: :topics
        map :authors, to: :authors
        map :contacts, to: :contacts
        map :media, to: :media
        map :links, to: :links
        map :boilerplate, to: :boilerplate
        map :rights, to: :rights
        map :timestamps, to: :timestamps
        map :body, to: :body
      end

      json do
        map :id, to: :id
        map :version, to: :version
        map :status, to: :status
        map :supersedes, to: :supersedes
        map :guid, to: :guid
        map :headline, to: :headline
        map :subheadline, to: :subheadline
        map "shortHeadline", to: :shortHeadline
        map :dateline, to: :dateline
        map :embargo, to: :embargo
        map :language, to: :language
        map "editionOf", to: :editionOf
        map :origin, to: :origin
        map :distribution, to: :distribution
        map :subjects, to: :subjects
        map :topics, to: :topics
        map :authors, to: :authors
        map :contacts, to: :contacts
        map :media, to: :media
        map :links, to: :links
        map :boilerplate, to: :boilerplate
        map :rights, to: :rights
        map :timestamps, to: :timestamps
        map :body, to: :body
      end

      def plain_headline
        headline&.content
      end

      def public? =
        %w[published corrected retracted].include?(status)
    end
  end
end
