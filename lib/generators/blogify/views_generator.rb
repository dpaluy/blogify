# frozen_string_literal: true

module Blogify
  module Generators
    class ViewsGenerator < Rails::Generators::Base
      source_root File.expand_path("../../../app/views/blogify", __dir__)

      desc "Copies Blogify views to your application for customization"

      def copy_views
        directory "posts", "app/views/blogify/posts"
        directory "shared", "app/views/blogify/shared"
        # Add other view directories as needed

        say "Blogify views have been copied to your application", :green
      end
    end
  end
end
