# frozen_string_literal: true

module Wire
  module Validation
    # Closed-vocabulary and registry closure: status, subjects, media
    # roles, link relations, distribution sites, origin site.
    class VocabularyCheck < Check
      def id = "vocabulary"
      def violations(record, context)
        item = record.item
        out = []
        out << add(item.id, "status #{item.status.inspect} not in status vocabulary") unless context.status.values.include?(item.status)

        item.subjects.each do |s|
          out << add(item.id, "subject #{s.inspect} not in subjects vocabulary") unless context.subjects.values.include?(s)
        end

        item.media.each do |m|
          next if m.role.nil?

          unless context.media_roles.values.include?(m.role)
            out << add(item.id, "media role #{m.role.inspect} not in media-roles vocabulary")
          end
        end

        item.links.each do |l|
          unless context.link_relations.values.include?(l.rel)
            out << add(item.id, "link relation #{l.rel.inspect} not in link-relations vocabulary")
          end
        end

        (item.distribution - [item.origin.site]).each do |site|
          out << add(item.id, "distribution site #{site.inspect} not in sites registry") unless context.site_ids.include?(site)
        end

        out << add(item.id, "origin site #{item.origin.site.inspect} not in sites registry") unless context.site_ids.include?(item.origin.site)
        out
      end
    end
  end
end
