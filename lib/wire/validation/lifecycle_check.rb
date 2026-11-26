# frozen_string_literal: true

module Wire
  module Validation
    # Lifecycle invariants: status transitions, embargo, supersedes,
    # publication timestamps.
    class LifecycleCheck < Check
      def id = "lifecycle"
      PUBLIC_STATES = %w[published corrected retracted].freeze

      def violations(record, _context)
        item = record.item
        out = []
        out << add(item.id, "embargo required while status is scheduled") if item.status == "scheduled" && item.embargo.nil?

        if PUBLIC_STATES.include?(item.status) && item.timestamps&.published.nil?
          out << add(item.id, "published timestamp required for status #{item.status}")
        end

        if item.status == "corrected" && item.supersedes.nil?
          out << add(item.id, "supersedes required for status corrected")
        end

        out << add(item.id, "version must be a positive integer") unless item.version.to_i >= 1
        out
      end
    end
  end
end
