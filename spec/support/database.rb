# frozen_string_literal: true

# Configure ActiveRecord for testing
ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

# Load schema
ActiveRecord::Schema.verbose = false
load File.expand_path("../dummy/db/schema.rb", __dir__)
