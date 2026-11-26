# frozen_string_literal: true

module Wire
  module Models
    class BoilerplateRef < Lutaml::Model::Serializable
      attribute :id, :string

      yaml do
        map :id, to: :id
      end

      json do
        map :id, to: :id
      end
    end
  end
end
