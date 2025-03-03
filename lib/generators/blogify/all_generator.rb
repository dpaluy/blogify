# frozen_string_literal: true

module Blogify
  module Generators
    class AllGenerator < Rails::Generators::Base
      desc "Generates all Blogify components (config, views, controllers, migration)"

      def run_all_generators
        generate "blogify:config"
        generate "blogify:views"
        generate "blogify:controllers"
        generate "blogify:migration"
      end
    end
  end
end
