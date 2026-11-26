# frozen_string_literal: true

module Wire
  module Models
    class MediaRendition < Lutaml::Model::Serializable
      attribute :variant, :string
      attribute :href, :string
      attribute :width, :integer
      attribute :height, :integer

      yaml do
        map :variant, to: :variant
        map :href, to: :href
        map :width, to: :width
        map :height, to: :height
      end

      json do
        map :variant, to: :variant
        map :href, to: :href
        map :width, to: :width
        map :height, to: :height
      end
    end
  end
end
