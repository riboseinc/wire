# frozen_string_literal: true

module Wire
  module Models
    class BodySource < Lutaml::Model::Serializable
      attribute :format, :string
      attribute :profile, :string
      attribute :path, :string

      yaml do
        map :format, to: :format
        map :profile, to: :profile
        map :path, to: :path
      end

      json do
        map :format, to: :format
        map :profile, to: :profile
        map :path, to: :path
      end
    end
  end
end
