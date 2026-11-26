# frozen_string_literal: true

module Wire
  module Publish
    # Atom 1.0 rendering of the feed. Rendering an XML document (a view
    # over models), not model serialization.
    module AtomFeed
      TEMPLATE = <<~XML
        <?xml version="1.0" encoding="utf-8"?>
        <feed xmlns="http://www.w3.org/2005/Atom">
          <title>%<title>s</title>
          <id>%<id>s</id>
          <updated>%<updated>s</updated>
          %<entries>s
        </feed>
      XML

      ENTRY = <<~XML
        <entry>
          <title>%<title>s</title>
          <id>%<id>s</id>
          <link href="%<href>s" rel="alternate"/>
          <updated>%<updated>s</updated>
        </entry>
      XML

      def self.render(title:, id:, updated:, entries:)
        rendered = entries.map do |e|
          format(ENTRY,
                 title: escape(e.headline),
                 id: escape(e.canonical),
                 href: escape(e.canonical),
                 updated: e.published)
        end.join("\n  ")
        format(TEMPLATE, title: escape(title), id: escape(id),
                         updated: updated, entries: rendered)
      end

      def self.escape(text)
        text.to_s.gsub("&", "&amp;").gsub("<", "&lt;").gsub(">", "&gt;")
      end
    end
  end
end
