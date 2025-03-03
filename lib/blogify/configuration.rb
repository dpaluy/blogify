# frozen_string_literal: true

module Blogify
  # Configuration class for Blogify
  # This class centralizes all configuration options and provides better documentation and type checking
  class Configuration
    # Layout configuration
    attr_accessor :blog_layout, :post_layout

    # SEO configuration
    attr_accessor :site_name, :twitter_site, :site_logo, :locale, :blog_title, :blog_description

    # Slug configuration
    attr_accessor :slug_format

    # Featured image configuration
    attr_accessor :featured_image_sizes, :featured_image_max_size, :featured_image_content_types

    # Default SEO configuration
    attr_accessor :default_meta_title_format, :default_meta_description_format

    # Social media configuration
    attr_accessor :facebook_app_id, :twitter_creator, :social_share_buttons

    # Schema.org configuration
    attr_accessor :schema_org_type, :organization_schema, :breadcrumb_schema_enabled

    # Database configuration
    attr_accessor :table_name

    def initialize
      # Layout defaults
      @blog_layout = "blogify/blog"
      @post_layout = "blogify/post"

      # SEO defaults
      @site_name = "Blogify"
      @twitter_site = nil
      @site_logo = nil
      @locale = "en"
      @blog_title = "Blog"
      @blog_description = "Latest blog posts"

      # Slug defaults
      @slug_format = :default # Options: :default, :date_prefix, :date_month_prefix, :custom

      # Featured image defaults
      @featured_image_sizes = {
        thumbnail: { resize_to_limit: [300, 300] },
        medium: { resize_to_limit: [600, 600] },
        large: { resize_to_limit: [1200, 1200] }
      }
      @featured_image_max_size = 5 * 1024 * 1024 # 5 MB in bytes
      @featured_image_content_types = ["image/png", "image/jpeg", "image/jpg", "image/gif", "image/webp"]

      # Default SEO format strings
      @default_meta_title_format = "%<title>s | %<site_name>s"
      @default_meta_description_format = "%<excerpt>s"

      # Social media defaults
      @facebook_app_id = nil
      @twitter_creator = nil
      @social_share_buttons = [:twitter, :facebook, :linkedin]

      # Schema.org defaults
      @schema_org_type = "BlogPosting"
      @organization_schema = nil
      @breadcrumb_schema_enabled = true

      # Database defaults
      @table_name = "blogify_posts"
    end

    # Validates the configuration
    def validate!
      validate_slug_format
      validate_featured_image_sizes
      validate_social_share_buttons
      self
    end

    private

    def validate_slug_format
      valid_formats = [:default, :date_prefix, :date_month_prefix, :custom]
      return if valid_formats.include?(@slug_format)

      raise ArgumentError, "Invalid slug format: #{@slug_format}. Valid options are: #{valid_formats.join(", ")}"
    end

    def validate_featured_image_sizes
      raise ArgumentError, "featured_image_sizes must be a Hash" unless @featured_image_sizes.is_a?(Hash)

      @featured_image_sizes.each_value do |value|
        unless value.is_a?(Hash) && value.key?(:resize_to_limit)
          raise ArgumentError, "Each featured_image_size must be a Hash with a :resize_to_limit key"
        end
      end
    end

    def validate_social_share_buttons
      valid_buttons = [:twitter, :facebook, :linkedin, :email, :pinterest]
      @social_share_buttons.each do |button|
        unless valid_buttons.include?(button)
          raise ArgumentError, "Invalid social share button: #{button}. Valid options are: #{valid_buttons.join(", ")}"
        end
      end
    end
  end
end
