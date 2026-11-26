# frozen_string_literal: true

module Wire
  module Validation
    # Encapsulated media integrity: referenced files exist; content
    # images carry alt text.
    class MediaCheck < Check
      def id = "media"
      CONTENT_ROLES = %w[hero figure].freeze

      def violations(record, _context)
        item = record.item
        out = []
        item.media.each do |asset|
          path = record.media_path(asset)
          out << add(item.id, "media #{asset.id.inspect} missing file at #{asset.href}") unless File.exist?(path)

          if CONTENT_ROLES.include?(asset.role) && asset.altText.nil?
            out << add(item.id, "media #{asset.id.inspect} with role #{asset.role} requires altText")
          end
        end
        out << add(item.id, "body source missing at #{record.item.body.path}") unless File.exist?(record.body_path)
        out
      end
    end
  end
end
