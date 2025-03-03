# frozen_string_literal: true

module Blogify
  class SlugGenerator
    attr_reader :post, :title, :published_at, :format

    def initialize(post)
      @post = post
      @title = post.title
      @published_at = post.published_at || Time.current
      @format = Blogify.config.slug_format
    end

    def generate
      case format
      when :date_prefix
        "#{date_prefix}-#{parameterized_title}"
      when :date_month_prefix
        "#{date_month_prefix}-#{parameterized_title}"
      when :custom
        custom_slug
      else
        parameterized_title
      end
    end

    private

    def parameterized_title
      title.to_s.parameterize
    end

    def date_prefix
      published_at.strftime("%Y-%m-%d")
    end

    def date_month_prefix
      published_at.strftime("%Y-%m")
    end

    # This method can be overridden in a custom SlugGenerator
    # to implement a custom slug format
    def custom_slug
      # Default implementation falls back to parameterized_title
      # Override this method in your custom SlugGenerator
      parameterized_title
    end
  end
end
