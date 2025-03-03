# frozen_string_literal: true

module Blogify
  module SeoHelper
    # Generate basic meta tags for SEO
    def meta_tags(post = nil)
      tags = []

      if post.present?
        tags << tag.meta(name: "description", content: post.meta_description) if post.meta_description.present?
        tags << tag.meta(name: "keywords", content: post.meta_data["keywords"]) if post.meta_data.try(:[],
                                                                                                      "keywords").present?
        tags << tag.title(post.meta_title || post.title)
        tags << tag.link(rel: "canonical", href: blogify.post_url(post))
      else
        # Default meta tags for blog index
        if Blogify.config.blog_description.present?
          tags << tag.meta(name: "description",
                           content: Blogify.config.blog_description)
        end
        tags << tag.title(Blogify.config.blog_title)
      end

      safe_join(tags)
    end

    # Generate OpenGraph meta tags
    def open_graph_tags(post = nil)
      tags = []

      # Default OpenGraph tags
      tags << tag.meta(property: "og:site_name", content: Blogify.config.site_name)
      tags << tag.meta(property: "og:locale", content: Blogify.config.locale)

      # Add Facebook App ID if configured
      if Blogify.config.facebook_app_id.present?
        tags << tag.meta(property: "fb:app_id", content: Blogify.config.facebook_app_id)
      end

      if post.present?
        tags << tag.meta(property: "og:type", content: "post")
        tags << tag.meta(property: "og:title", content: post.meta_title || post.title)
        tags << tag.meta(property: "og:description", content: post.meta_description) if post.meta_description.present?
        tags << tag.meta(property: "og:url", content: blogify.post_url(post))

        # Add published time if available
        if post.published_at.present?
          tags << tag.meta(property: "post:published_time", content: post.published_at.iso8601)
          tags << tag.meta(property: "post:modified_time", content: post.updated_at.iso8601)
        end

        # Add image if available
        if post.respond_to?(:featured_image) && post.featured_image.attached?
          tags << tag.meta(property: "og:image", content: url_for(post.featured_image))
          tags << tag.meta(property: "og:image:alt", content: post.meta_title || post.title)
        end
      else
        # Default OpenGraph tags for blog index
        tags << tag.meta(property: "og:type", content: "website")
        tags << tag.meta(property: "og:title", content: Blogify.config.blog_title)
        if Blogify.config.blog_description.present?
          tags << tag.meta(property: "og:description",
                           content: Blogify.config.blog_description)
        end
        tags << tag.meta(property: "og:url", content: blogify.posts_url)

        # Add site logo if configured
        if Blogify.config.site_logo.present?
          tags << tag.meta(property: "og:image", content: Blogify.config.site_logo)
          tags << tag.meta(property: "og:image:alt", content: Blogify.config.site_name)
        end
      end

      safe_join(tags)
    end

    # Generate Twitter Card meta tags
    def twitter_card_tags(post = nil)
      tags = []

      # Default Twitter Card type
      tags << tag.meta(name: "twitter:card", content: "summary_large_image")

      # Add Twitter site handle if configured
      if Blogify.config.twitter_site.present?
        tags << tag.meta(name: "twitter:site", content: Blogify.config.twitter_site)
      end

      # Add Twitter creator handle if configured
      if Blogify.config.twitter_creator.present?
        tags << tag.meta(name: "twitter:creator", content: Blogify.config.twitter_creator)
      end

      if post.present?
        tags << tag.meta(name: "twitter:title", content: post.meta_title || post.title)
        tags << tag.meta(name: "twitter:description", content: post.meta_description) if post.meta_description.present?

        # Add image if available
        if post.respond_to?(:featured_image) && post.featured_image.attached?
          tags << tag.meta(name: "twitter:image", content: url_for(post.featured_image))
          tags << tag.meta(name: "twitter:image:alt", content: post.meta_title || post.title)
        end
      else
        # Default Twitter Card tags for blog index
        tags << tag.meta(name: "twitter:title", content: Blogify.config.blog_title)
        if Blogify.config.blog_description.present?
          tags << tag.meta(name: "twitter:description",
                           content: Blogify.config.blog_description)
        end

        # Add site logo if configured
        if Blogify.config.site_logo.present?
          tags << tag.meta(name: "twitter:image", content: Blogify.config.site_logo)
          tags << tag.meta(name: "twitter:image:alt", content: Blogify.config.site_name)
        end
      end

      safe_join(tags)
    end

    # Generate JSON-LD schema for blog posts
    def json_ld_schema(post = nil)
      if post.present?
        schema_generator = SeoSchemaGenerator.new(post, self)
        tag.script(schema_generator.generate.to_json.html_safe, type: "application/ld+json")
      elsif Blogify.config.organization_schema.present?
        # Organization schema for blog index
        tag.script(Blogify.config.organization_schema.to_json.html_safe, type: "application/ld+json")
      end
    end

    # Generate breadcrumb schema
    def breadcrumb_schema(post = nil)
      return unless Blogify.config.breadcrumb_schema_enabled

      items = [
        {
          "@type" => "ListItem",
          "position" => 1,
          "name" => "Home",
          "item" => root_url
        },
        {
          "@type" => "ListItem",
          "position" => 2,
          "name" => Blogify.config.blog_title,
          "item" => blogify.posts_url
        }
      ]

      if post.present?
        items << {
          "@type" => "ListItem",
          "position" => 3,
          "name" => post.title,
          "item" => blogify.post_url(post)
        }
      end

      schema = {
        "@context" => "https://schema.org",
        "@type" => "BreadcrumbList",
        "itemListElement" => items
      }

      tag.script(schema.to_json.html_safe, type: "application/ld+json")
    end

    # Combine all SEO tags
    def all_seo_tags(post = nil)
      tags = []
      tags << meta_tags(post)
      tags << open_graph_tags(post)
      tags << twitter_card_tags(post)
      tags << json_ld_schema(post)
      tags << breadcrumb_schema(post) if Blogify.config.breadcrumb_schema_enabled

      safe_join(tags)
    end

    # Generate social share buttons
    def social_share_buttons(post)
      return unless post.present?

      buttons = []
      enabled_buttons = Blogify.config.social_share_buttons

      if enabled_buttons.include?(:twitter)
        buttons << link_to("Share on Twitter",
                           "https://twitter.com/intent/tweet?url=#{CGI.escape(blogify.post_url(post))}&text=#{CGI.escape(post.title)}",
                           target: "_blank",
                           class: "blogify-share-button blogify-twitter-share")
      end

      if enabled_buttons.include?(:facebook)
        buttons << link_to("Share on Facebook",
                           "https://www.facebook.com/sharer/sharer.php?u=#{CGI.escape(blogify.post_url(post))}",
                           target: "_blank",
                           class: "blogify-share-button blogify-facebook-share")
      end

      if enabled_buttons.include?(:linkedin)
        buttons << link_to("Share on LinkedIn",
                           "https://www.linkedin.com/sharing/share-offsite/?url=#{CGI.escape(blogify.post_url(post))}",
                           target: "_blank",
                           class: "blogify-share-button blogify-linkedin-share")
      end

      if enabled_buttons.include?(:pinterest) && post.featured_image.attached?
        buttons << link_to("Pin on Pinterest",
                           "https://pinterest.com/pin/create/button/?url=#{CGI.escape(blogify.post_url(post))}&media=#{CGI.escape(url_for(post.featured_image))}&description=#{CGI.escape(post.meta_description || post.title)}",
                           target: "_blank",
                           class: "blogify-share-button blogify-pinterest-share")
      end

      if enabled_buttons.include?(:email)
        buttons << mail_to("", "Share via Email",
                           subject: post.title,
                           body: "Check out this post: #{blogify.post_url(post)}",
                           class: "blogify-share-button blogify-email-share")
      end

      content_tag(:div, safe_join(buttons), class: "blogify-social-share-buttons")
    end
  end
end
