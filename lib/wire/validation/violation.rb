# frozen_string_literal: true

module Wire
  module Validation
    Violation = Struct.new(:item_id, :check, :message, keyword_init: true)
  end
end
