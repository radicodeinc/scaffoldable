# frozen_string_literal: true

require "rails"
# require "active_storage"

module Scaffoldable
  class Engine < Rails::Engine # :nodoc:
    isolate_namespace Scaffoldable
    config.eager_load_namespaces << Scaffoldable
  end
end
