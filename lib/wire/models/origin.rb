# frozen_string_literal: true

module Wire
  module Models
    class Origin < Lutaml::Model::Serializable
      attribute :site, :string
      attribute :canonical, :string

      yaml do
        map :site, to: :site
        map :canonical, to: :canonical
      end

      json do
        map :site, to: :site
        map :canonical, to: :canonical
      end
    end
  end
end
