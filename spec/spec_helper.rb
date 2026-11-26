# frozen_string_literal: true

require "fileutils"
require "json"
require "tmpdir"
require "time"

require_relative "../lib/wire"

RSpec.configure do |config|
  config.order = :random
end
