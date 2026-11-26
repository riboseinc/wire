# frozen_string_literal: true

module Wire
  module Validation
    # Abstract check. Subclasses declare `id` and implement
    # `violations(record, context)` -> Array<Violation>.
    class Check
      def id
        raise NotImplementedError, "#{self.class} must declare #id"
      end

      def violations(record, context)
        raise NotImplementedError, "#{self.class} must implement #violations"
      end

      private

      def add(item_id, message) =
        Violation.new(item_id: item_id, check: id, message: message)
    end
  end
end
