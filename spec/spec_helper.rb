# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require File.expand_path("dummy/config/environment", __dir__)
require "rspec/rails"

# Require the gem itself
require "blogify"
require "support/database"
require "support/shoulda_matchers"

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.fixture_paths = [File.expand_path("fixtures", __dir__)]
  config.global_fixtures = :all

  config.before(:suite) do
    ActiveRecord::Migration.verbose = false
  end

  config.around(:each) do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
