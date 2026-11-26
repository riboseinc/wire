# frozen_string_literal: true

module Wire
  module Validation
    # Shared, read-only facts handed to every check.
    Context = Struct.new(:status, :subjects, :media_roles, :link_relations,
                         :site_ids, keyword_init: true)

    # Runs every registered check over every record.
    class Runner
      attr_reader :checks, :context

      def self.build(vocab_dir: Vocabulary.default_dir,
                     sites: SitesRegistry.load)
        new(checks: Validation.checks,
            context: Context.new(
              status: Vocabulary.load("status", dir: vocab_dir),
              subjects: Vocabulary.load("subjects", dir: vocab_dir),
              media_roles: Vocabulary.load("media-roles", dir: vocab_dir),
              link_relations: Vocabulary.load("link-relations", dir: vocab_dir),
              site_ids: sites.ids
            ))
      end

      def initialize(checks:, context:)
        @checks = checks.freeze
        @context = context.freeze
      end

      def run(records) =
        records.flat_map { |record| run_one(record) }

      def run_one(record) =
        checks.flat_map { |check| check.violations(record, context) }
    end
  end
end
