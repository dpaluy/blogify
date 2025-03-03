# frozen_string_literal: true

# Blogify Configuration
# This file contains the configuration options for the Blogify engine.
# You can customize these options to suit your needs.

Blogify.configure do |config|
  # Layout Configuration
  # ===================
  # These options control the layouts used for the blog and post pages.
  # config.blog_layout = "blogify/blog"
  # config.post_layout = "blogify/post"

  # SEO Configuration
  # ================
  # These options control the SEO-related settings for your blog.
  # config.site_name = "My Awesome Blog"
  # config.twitter_site = "@myblog"
  # config.site_logo = "https://example.com/logo.png"
  # config.locale = "en"
  # config.blog_title = "Blog"
  # config.blog_description = "Latest blog posts"

  # Slug Configuration
  # =================
  # This option controls how slugs are generated for your blog posts.
  # Options: :default, :date_prefix, :date_month_prefix, :custom
  # :default - Uses the post title (e.g., "my-awesome-post")
  # :date_prefix - Prefixes the slug with the date (e.g., "2023-01-01-my-awesome-post")
  # :date_month_prefix - Prefixes the slug with the year and month (e.g., "2023-01-my-awesome-post")
  # :custom - Uses a custom slug format (requires implementing a custom SlugGenerator)
  # config.slug_format = :default

  # Featured Image Configuration
  # ===========================
  # These options control how featured images are handled.
  # config.featured_image_sizes = {
  #   thumbnail: { resize_to_limit: [300, 300] },
  #   medium: { resize_to_limit: [600, 600] },
  #   large: { resize_to_limit: [1200, 1200] }
  # }
  # config.featured_image_max_size = 5 * 1024 * 1024 # 5 MB in bytes
  # config.featured_image_content_types = ["image/png", "image/jpeg", "image/jpg", "image/gif", "image/webp"]

  # Default SEO Format Strings
  # =========================
  # These options control the default format for meta titles and descriptions.
  # config.default_meta_title_format = "%{title} | %{site_name}"
  # config.default_meta_description_format = "%{excerpt}"

  # Social Media Configuration
  # =========================
  # These options control social media integration.
  # config.facebook_app_id = "123456789"
  # config.twitter_creator = "@author"
  # config.social_share_buttons = [:twitter, :facebook, :linkedin]

  # Schema.org Configuration
  # =======================
  # These options control Schema.org JSON-LD generation.
  # config.schema_org_type = "BlogPosting"
  # config.organization_schema = {
  #   "@type" => "Organization",
  #   "name" => "My Company",
  #   "url" => "https://example.com",
  #   "logo" => "https://example.com/logo.png"
  # }
  # config.breadcrumb_schema_enabled = true
end
