# frozen_string_literal: true

module Wire
  module Models
    class MediaAsset < Lutaml::Model::Serializable
      attribute :id, :string
      attribute :role, :string
      attribute :href, :string
      attribute :mimeType, :string
      attribute :altText, LocalizedString
      attribute :caption, LocalizedString
      attribute :credit, :string
      attribute :license, :string
      attribute :renditions, MediaRendition, collection: true

      yaml do
        map :id, to: :id
        map :role, to: :role
        map :href, to: :href
        map "mimeType", to: :mimeType
        map "altText", to: :altText
        map :caption, to: :caption
        map :credit, to: :credit
        map :license, to: :license
        map :renditions, to: :renditions
      end

      json do
        map :id, to: :id
        map :role, to: :role
        map :href, to: :href
        map "mimeType", to: :mimeType
        map "altText", to: :altText
        map :caption, to: :caption
        map :credit, to: :credit
        map :license, to: :license
        map :renditions, to: :renditions
      end
    end
  end
end
