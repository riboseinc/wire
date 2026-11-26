# frozen_string_literal: true

module Wire
  module Publish
    # Deterministic, path-safe rendering of a URN item id:
    # "urn:ribose:news:2026-09-02:slug" -> "2026-09-02-slug".
    module UrnPath
      PREFIX = "urn:ribose:news:".freeze

      def self.call(item_id)
        rest = item_id.start_with?(PREFIX) ? item_id.delete_prefix(PREFIX) : item_id
        rest.tr(":", "-")
      end
    end
  end
end
