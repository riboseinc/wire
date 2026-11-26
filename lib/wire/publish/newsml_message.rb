# frozen_string_literal: true

require "newsmlg2"

module Wire
  module Publish
    # NewsML-G2 (IPTC News Architecture) projection of the published items,
    # for interchange with newsroom systems. The items stay SSOT in
    # item.yaml / news.json; this is a derived wire format like Atom/ninjs.
    class NewsmlMessage
      PROVIDER_QCODE = "nprov:ribose"
      PROVIDER_NAME = "Ribose"

      def self.render(items:, generated_at:)
        message = Newsmlg2.build_news_message do |m|
          m.header do |h|
            h.sent generated_at.iso8601
            h.sender PROVIDER_NAME
          end
        end
        message.item.item_set = Newsmlg2::ItemSet.new(
          news_items: items.map { |item| build_item(item).item }
        )
        message.to_xml
      end

      # Builder blocks run via instance_eval on a Newsmlg2::Builder::Node,
      # so every value must be computed BEFORE entering the DSL — an
      # unqualified method call inside a block becomes an attribute
      # assignment on the node instead.
      def self.build_item(item)
        guid = item.guid || item.id
        version = version_created(item)
        created = content_created(item)
        headline = item.plain_headline
        slugline = item.shortHeadline&.content
        description = item.subheadline&.content
        byline = item.authors.map(&:name).join(", ")
        located = located(item)

        Newsmlg2.build_news_item(guid: guid, lang: item.language) do |i|
          i.item_meta do |meta|
            meta.item_class qcode: "ninat:text"
            meta.provider qcode: PROVIDER_QCODE do |p|
              p.name PROVIDER_NAME
            end
            meta.version_created version if version
          end
          i.content_meta do |cm|
            cm.content_created created if created
            cm.headline headline
            cm.slugline slugline if slugline
            cm.description description if description
            cm.by byline unless byline.empty?
            unless located.to_s.empty?
              cm.located do |l|
                l.name located
              end
            end
          end
        end
      end

      def self.version_created(item)
        (item.timestamps&.updated || item.timestamps&.created)&.iso8601
      end

      def self.content_created(item)
        item.dateline&.date&.iso8601
      end

      def self.located(item)
        [item.dateline&.place, item.dateline&.country].compact.join(", ")
      end
    end
  end
end
