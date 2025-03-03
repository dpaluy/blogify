# frozen_string_literal: true

module Blogify
  module Generators
    class ControllersGenerator < Rails::Generators::Base
      source_root File.expand_path("../../../app/controllers/blogify", __dir__)

      desc "Copies Blogify controllers to your application for customization"

      def copy_controllers
        directory ".", "app/controllers/blogify"

        # Update the namespacing in the copied controllers
        Dir.glob("app/controllers/blogify/**/*_controller.rb").each do |file|
          gsub_file file, "module Blogify", "class Blogify"
          gsub_file file, "class ", "class "
          gsub_file file, "< ApplicationController", "< ::ApplicationController"
          gsub_file file, "end\nend", "end"
        end

        say "Blogify controllers have been copied to your application", :green
        say "NOTE: Remember to update your routes to use your custom controllers", :yellow
      end
    end
  end
end
