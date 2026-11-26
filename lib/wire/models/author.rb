# frozen_string_literal: true

module Wire
  module Models
    class Author < Lutaml::Model::Serializable
      attribute :name, :string
      attribute :email, :string
      attribute :organization, :string
      attribute :uri, :string

      yaml do
        map :name, to: :name
        map :email, to: :email
        map :organization, to: :organization
        map :uri, to: :uri
      end

      json do
        map :name, to: :name
        map :email, to: :email
        map :organization, to: :organization
        map :uri, to: :uri
      end
    end
  end
end
