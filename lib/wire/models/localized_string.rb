# frozen_string_literal: true

module Wire
  module Models
    class LocalizedString < Lutaml::Model::Serializable
      attribute :language, :string, collection: true
      attribute :script, :string
      attribute :country, :string
      attribute :content, :string

      yaml do
        map :language, to: :language
        map :script, to: :script
        map :country, to: :country
        map :content, to: :content
      end

      json do
        map :language, to: :language
        map :script, to: :script
        map :country, to: :country
        map :content, to: :content
      end
    end
  end
end
