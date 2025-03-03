# frozen_string_literal: true

module Blogify
  module Generators
    class MigrationGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      class_option :table_name, type: :string, default: "blogify_posts",
                                desc: "The name of the table to be created for blog posts"

      def copy_migration
        @table_name = options[:table_name]
        migration_template "create_blogify_posts_migration.rb.tt",
                           "db/migrate/create_#{@table_name}.rb",
                           migration_version: migration_version
      end

      private

      def migration_version
        "[#{ActiveRecord::Migration.current_version}]" if ActiveRecord::Migration.respond_to?(:current_version)
      end
    end
  end
end
