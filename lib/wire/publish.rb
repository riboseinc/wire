# frozen_string_literal: true

module Wire
  # Publishing: turns validated items into the static news files
  # (news.json index, per-article folders, feeds).
  module Publish
    autoload :IndexEntry, "wire/publish/index_entry"
    autoload :FullEntry, "wire/publish/full_entry"
    autoload :MediaAssetSummary, "wire/publish/full_entry"
    autoload :NinjsItem, "wire/publish/ninjs_item"
    autoload :Publisher, "wire/publish/publisher"
    autoload :AtomFeed, "wire/publish/atom_feed"
    autoload :UrnPath, "wire/publish/urn_path"
    autoload :NewsmlMessage, "wire/publish/newsml_message"
  end
end
