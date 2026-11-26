# frozen_string_literal: true

module Wire
  module Models
    # Wire-local datatypes mirroring basicdoc datatypes (LutaML source of
    # truth: metanorma/basicdoc-models). To be aliased to the basicdoc
    # submodule types when that integration lands -- never duplicated
    # beyond this namespace.
    autoload :LocalizedString, "wire/models/localized_string"

    autoload :Dateline, "wire/models/dateline"
    autoload :Origin, "wire/models/origin"
    autoload :BodySource, "wire/models/body_source"
    autoload :MediaAsset, "wire/models/media_asset"
    autoload :MediaRendition, "wire/models/media_rendition"
    autoload :RelatedLink, "wire/models/related_link"
    autoload :Author, "wire/models/author"
    autoload :MediaContact, "wire/models/media_contact"
    autoload :Rights, "wire/models/rights"
    autoload :Timestamps, "wire/models/timestamps"
    autoload :BoilerplateRef, "wire/models/boilerplate_ref"
    autoload :NewsItem, "wire/models/news_item"
  end
end
