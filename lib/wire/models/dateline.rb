# frozen_string_literal: true

module Wire
  module Models
    class Dateline < Lutaml::Model::Serializable
      attribute :place, :string
      attribute :country, :string
      attribute :date, :date_time

      yaml do
        map :place, to: :place
        map :country, to: :country
        map :date, to: :date
      end

      json do
        map :place, to: :place
        map :country, to: :country
        map :date, to: :date
      end
    end
  end
end
