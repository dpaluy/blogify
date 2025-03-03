# frozen_string_literal: true

module Blogify
  class Engine < ::Rails::Engine
    isolate_namespace Blogify

    # Configuration options for layouts, etc.
    config.blog_layout = "blogify/blog"
    config.article_layout = "blogify/article"
  end
end