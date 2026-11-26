# frozen_string_literal: true

module Wire
  module Models
    class RelatedLink < Lutaml::Model::Serializable
      attribute :rel, :string
      attribute :href, :string
      attribute :title, LocalizedString

      yaml do
        map :rel, to: :rel
        map :href, to: :href
        map :title, to: :title
      end

      json do
        map :rel, to: :rel
        map :href, to: :href
        map :title, to: :title
      end
    end
  end
end
