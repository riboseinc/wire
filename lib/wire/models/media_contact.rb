# frozen_string_literal: true

module Wire
  module Models
    class MediaContact < Lutaml::Model::Serializable
      attribute :name, :string
      attribute :email, :string
      attribute :phone, :string

      yaml do
        map :name, to: :name
        map :email, to: :email
        map :phone, to: :phone
      end

      json do
        map :name, to: :name
        map :email, to: :email
        map :phone, to: :phone
      end
    end
  end
end
