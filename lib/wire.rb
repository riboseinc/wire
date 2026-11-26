# frozen_string_literal: true

require "lutaml/model"

module Wire
  autoload :Version, "wire/version"
  autoload :Models, "wire/models"
  autoload :Vocabulary, "wire/vocabulary"
  autoload :SitesRegistry, "wire/sites_registry"
  autoload :ItemLoader, "wire/item_loader"
  autoload :Validation, "wire/validation"
  autoload :Publish, "wire/publish"
  autoload :CLI, "wire/cli"
end
