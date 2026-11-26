# frozen_string_literal: true

module Wire
  # Scans the items tree and loads every item.yaml as a NewsItem.
  # One record per article directory; the record owns its paths so
  # validators and the publisher never re-derive them.
  class ItemLoader
    Record = Struct.new(:item, :dir, :envelope_path, keyword_init: true) do
      def id = item.id

      def body_path = File.join(dir, item.body.path)

      def media_path(asset) = File.join(dir, asset.href)
    end

    attr_reader :root

    def initialize(root:)
      @root = root
    end

    def records =
      Dir.glob(File.join(root, "**", "item.yaml")).sort.map { |path| load_record(path) }

    private

    def load_record(path)
      dir = File.dirname(path)
      item = Models::NewsItem.from_yaml(File.read(path))
      Record.new(item: item, dir: dir, envelope_path: path)
    end
  end
end
