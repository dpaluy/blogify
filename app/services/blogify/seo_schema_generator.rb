# frozen_string_literal: true

module Blogify
  class SeoSchemaGenerator
    attr_reader :post, :view_context

    def initialize(post, view_context = nil)
      @post = post
      @view_context = view_context
    end

    def generate
      return {} unless post.present?

      case Blogify.config.schema_org_type
      when "BlogPosting"
        blog_posting_schema
      when "Article"
        post_schema
      when "NewsArticle"
        news_post_schema
      else
        blog_posting_schema
      end
    end

    private

    def blog_posting_schema
      schema = {
        "@context" => "https://schema.org",
        "@type" => "BlogPosting",
        "headline" => post.meta_title || post.title,
        "datePublished" => post.published_at&.iso8601,
        "dateModified" => post.updated_at&.iso8601
      }

      add_common_properties(schema)
    end

    def post_schema
      schema = {
        "@context" => "https://schema.org",
        "@type" => "Article",
        "headline" => post.meta_title || post.title,
        "datePublished" => post.published_at&.iso8601,
        "dateModified" => post.updated_at&.iso8601
      }

      add_common_properties(schema)
    end

    def news_post_schema
      schema = {
        "@context" => "https://schema.org",
        "@type" => "NewsArticle",
        "headline" => post.meta_title || post.title,
        "datePublished" => post.published_at&.iso8601,
        "dateModified" => post.updated_at&.iso8601
      }

      add_common_properties(schema)
    end

    def add_common_properties(schema)
      # Add URL if view_context is available
      if view_context.present?
        schema["url"] = view_context.blogify.post_url(post)
        schema["mainEntityOfPage"] = {
          "@type" => "WebPage",
          "@id" => view_context.blogify.post_url(post)
        }
      end

      # Add description if available
      schema["description"] = post.meta_description if post.meta_description.present?

      # Add image if available
      if post.respond_to?(:featured_image) && post.featured_image.attached? && view_context.present?
        schema["image"] = {
          "@type" => "ImageObject",
          "url" => view_context.url_for(post.featured_image)
        }
      end

      # Add author if available
      if post.respond_to?(:author) && post.author.present?
        schema["author"] = {
          "@type" => "Person",
          "name" => post.author
        }
      end

      # Add publisher if site name is configured
      if Blogify.config.site_name.present?
        schema["publisher"] = {
          "@type" => "Organization",
          "name" => Blogify.config.site_name
        }

        # Add logo if configured
        if Blogify.config.site_logo.present?
          schema["publisher"]["logo"] = {
            "@type" => "ImageObject",
            "url" => Blogify.config.site_logo
          }
        end
      end

      # Add post body if content is available
      schema["postBody"] = post.content if post.respond_to?(:content) && post.content.present?

      schema
    end
  end
end
