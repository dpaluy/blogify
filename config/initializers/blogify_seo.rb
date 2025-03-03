# frozen_string_literal: true

# Include Blogify SEO helper in the application
ActiveSupport.on_load(:action_controller) do
  helper Blogify::SeoHelper if defined?(Blogify::SeoHelper)
end
