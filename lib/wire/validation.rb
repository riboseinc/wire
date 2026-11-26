# frozen_string_literal: true

module Wire
  # Validation pipeline. Checks are classes; Wire::Validation.checks is
  # the single registration point -- adding a check means adding one
  # line there, nothing else changes (OCP).
  module Validation
    autoload :Violation, "wire/validation/violation"
    autoload :Check, "wire/validation/check"
    autoload :VocabularyCheck, "wire/validation/vocabulary_check"
    autoload :MediaCheck, "wire/validation/media_check"
    autoload :LifecycleCheck, "wire/validation/lifecycle_check"
    autoload :IdFormatCheck, "wire/validation/id_format_check"
    autoload :Runner, "wire/validation/runner"

    def self.checks =
      [VocabularyCheck.new, MediaCheck.new, LifecycleCheck.new, IdFormatCheck.new]
  end
end
