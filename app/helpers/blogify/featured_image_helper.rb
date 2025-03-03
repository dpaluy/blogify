# frozen_string_literal: true

module Blogify
  module FeaturedImageHelper
    # Returns the URL for the featured image variant
    # @param post [Blogify::Post] the post
    # @param variant [Symbol] the variant to use (:thumbnail, :medium, :large)
    # @param default_url [String] the default URL to use if no featured image is attached
    # @return [String] the URL for the featured image variant
    def featured_image_url(post, variant = :medium, default_url = nil)
      return default_url unless post.featured_image.attached?

      variant_options = Blogify.config.featured_image_sizes[variant] || case variant
                                                                        when :thumbnail
                                                                          { resize_to_limit: [300, 300] }
                                                                        when :medium
                                                                          { resize_to_limit: [600, 600] }
                                                                        when :large
                                                                          { resize_to_limit: [1200, 1200] }
                                                                        else
                                                                          { resize_to_limit: [600, 600] }
                                                                        end

      url_for(post.featured_image.variant(**variant_options))
    end

    # Returns the HTML for the featured image
    # @param post [Blogify::Post] the post
    # @param variant [Symbol] the variant to use (:thumbnail, :medium, :large)
    # @param options [Hash] options to pass to the image_tag helper
    # @param default_url [String] the default URL to use if no featured image is attached
    # @return [String] the HTML for the featured image
    def featured_image_tag(post, variant = :medium, options = {}, default_url = nil)
      return if !post.featured_image.attached? && default_url.nil?

      url = featured_image_url(post, variant, default_url)

      # Set default alt text if not provided
      options[:alt] ||= post.title if post.respond_to?(:title)

      image_tag(url, options)
    end

    # Returns a responsive picture element for the featured image
    # @param post [Blogify::Post] the post
    # @param options [Hash] options to pass to the picture_tag helper
    # @return [String] the HTML for the responsive picture element
    def featured_image_picture(post, options = {})
      return unless post.featured_image.attached?

      sources = []

      # Add sources for different screen sizes
      if Blogify.config.featured_image_sizes[:large]
        sources << tag.source(
          srcset: url_for(post.featured_image.variant(**Blogify.config.featured_image_sizes[:large])),
          media: "(min-width: 1200px)"
        )
      end

      if Blogify.config.featured_image_sizes[:medium]
        sources << tag.source(
          srcset: url_for(post.featured_image.variant(**Blogify.config.featured_image_sizes[:medium])),
          media: "(min-width: 768px)"
        )
      end

      if Blogify.config.featured_image_sizes[:thumbnail]
        sources << tag.source(
          srcset: url_for(post.featured_image.variant(**Blogify.config.featured_image_sizes[:thumbnail])),
          media: "(max-width: 767px)"
        )
      end

      # Set default alt text if not provided
      options[:alt] ||= post.title if post.respond_to?(:title)

      # Create the picture element
      content_tag(:picture, safe_join([
                                        *sources,
                                        image_tag(
                                          url_for(post.featured_image.variant(**Blogify.config.featured_image_sizes[:medium])), options
                                        )
                                      ]))
    end
  end
end
