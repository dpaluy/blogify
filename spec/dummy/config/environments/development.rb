# frozen_string_literal: true

Dummy::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  config.eager_load = false

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Expands the lines which load the assets
  config.assets.debug = true

  # Set to_time to preserve timezone for Rails 8.1 compatibility
  config.active_support.to_time_preserves_timezone = :zone
end
