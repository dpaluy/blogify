# frozen_string_literal: true

module Blogify
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Creates a Blogify configuration initializer in config/initializers"

      def copy_initializer
        template "blogify.rb", "config/initializers/blogify.rb"
      end
    end
  end
end
