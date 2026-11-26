# frozen_string_literal: true

module Wire
  module Models
    class Rights < Lutaml::Model::Serializable
      attribute :license, :string
      attribute :holder, :string

      yaml do
        map :license, to: :license
        map :holder, to: :holder
      end

      json do
        map :license, to: :license
        map :holder, to: :holder
      end
    end
  end
end
