# frozen_string_literal: true

module Wire
  module Models
    class Timestamps < Lutaml::Model::Serializable
      attribute :created, :date_time
      attribute :updated, :date_time
      attribute :published, :date_time

      yaml do
        map :created, to: :created
        map :updated, to: :updated
        map :published, to: :published
      end

      json do
        map :created, to: :created
        map :updated, to: :updated
        map :published, to: :published
      end
    end
  end
end
