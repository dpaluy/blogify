# frozen_string_literal: true

require "blogify/version"
require "blogify/engine"

module Blogify
  # Configure the Blogify engine
  # @yield [config] Configuration instance
  # @example
  #   Blogify.configure do |config|
  #     config.site_name = "My Awesome Blog"
  #     config.twitter_site = "@myblog"
  #   end
  def self.configure
    yield(Engine.config) if block_given?
  end

  # Get the current configuration
  # @return [Blogify::Configuration] The current configuration
  def self.config
    Engine.config
  end
end
