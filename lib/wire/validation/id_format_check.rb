# frozen_string_literal: true

module Wire
  module Validation
    # Item ids carry the publication date so published URLs are always
    # full dates: urn:ribose:news:YYYY-MM-DD:slug -> /news/YYYY-MM-DD/slug.
    # Bare YYYY-MM segments are disallowed.
    class IdFormatCheck < Check
      def id = "id_format"

      ID_PATTERN = /\Aurn:ribose:news:\d{4}-\d{2}-\d{2}:[a-z0-9-]+\z/.freeze

      def violations(record, _context)
        item = record.item
        return [] if item.id.match?(ID_PATTERN)

        [add(item.id, "id must be urn:ribose:news:YYYY-MM-DD:slug with a full date")]
      end
    end
  end
end
