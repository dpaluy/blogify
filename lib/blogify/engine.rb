# frozen_string_literal: true

module Blogify
  class Engine < ::Rails::Engine
    isolate_namespace Blogify

    # Ensure ActiveStorage is loaded
    require "active_storage/engine" if defined?(ActiveStorage)

    # Load the configuration class
    require "blogify/configuration"

    # Create a class accessor for the configuration
    class_attribute :config

    # Initialize the configuration
    self.config = Configuration.new

    # Configuration initializer
    initializer "blogify.configuration" do
      # Validate the configuration after all initializers have run
      Blogify::Engine.config.validate!
    end

    # Allow users to configure the engine
    def self.configure
      yield(config) if block_given?
    end

    initializer "blogify.helpers" do
      ActiveSupport.on_load(:action_controller) do
        helper Blogify::SeoHelper
        helper Blogify::FeaturedImageHelper
      end
    end
  end
end
