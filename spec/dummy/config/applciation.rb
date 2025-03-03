# frozen_string_literal: true

require File.expand_path("boot", __dir__)

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

require "blogify"

module Dummy
  class Application < Rails::Application
    config.assets.version = "1.0"

    # Enable the asset pipeline
    config.assets.enabled = true

    config.i18n.enforce_available_locales = false
  end
end
