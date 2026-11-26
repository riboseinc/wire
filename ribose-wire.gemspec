# frozen_string_literal: true

require_relative "lib/wire/version"

Gem::Specification.new do |spec|
  spec.name = "ribose-wire"
  spec.version = Wire::VERSION
  spec.authors = ["Ribose Inc."]
  spec.email = ["open.source@ribose.com"]

  spec.summary = "News interchange for the Ribose site network."
  spec.description = "Models, validation, and publishing of Ribose news items."
  spec.homepage = "https://github.com/riboseinc/wire"
  spec.license = "MIT"

  spec.files = Dir["lib/**/*.rb", "exe/*", "vocabularies/*.yaml",
                   "registries/*.yaml", "profiles/*.yaml", "models/*.lml",
                   "README*", "LICENSE*"]
  spec.bindir = "exe"
  spec.executables = ["wire"]
  spec.require_paths = ["lib"]

  spec.add_dependency "lutaml-model", ">= 0.8.20", "< 0.9"
  spec.add_dependency "newsmlg2", ">= 0.1.1"
end
