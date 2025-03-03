# SEO Features in Blogify

Blogify includes comprehensive SEO features to help your blog posts rank better in search engines. This document explains how to use and configure these features.

## Table of Contents

1. [SEO-Friendly URLs](#seo-friendly-urls)
2. [Meta Tags](#meta-tags)
3. [OpenGraph and Twitter Cards](#opengraph-and-twitter-cards)
4. [JSON-LD Structured Data](#json-ld-structured-data)
5. [Breadcrumb Schema](#breadcrumb-schema)
6. [Configuration Options](#configuration-options)

## SEO-Friendly URLs

Blogify generates SEO-friendly URLs (slugs) for your blog posts. You can configure the format of these slugs in the configuration.

### Available Slug Formats

- `:default` - Uses the post title (e.g., "my-awesome-post")
- `:date_prefix` - Prefixes the slug with the date (e.g., "2023-01-01-my-awesome-post")
- `:date_month_prefix` - Prefixes the slug with the year and month (e.g., "2023-01-my-awesome-post")
- `:custom` - Uses a custom slug format (requires implementing a custom SlugGenerator)

### Configuration

```ruby
Blogify.configure do |config|
  config.slug_format = :date_prefix
end
```

### Custom Slug Format

To implement a custom slug format, create a class that inherits from `Blogify::SlugGenerator` and override the `custom_slug` method:

```ruby
# app/services/my_custom_slug_generator.rb
class MyCustomSlugGenerator < Blogify::SlugGenerator
  def custom_slug
    # Your custom slug generation logic
    "#{post.id}-#{parameterized_title}"
  end
end
```

## Meta Tags

Blogify automatically generates meta tags for your blog posts, including title, description, and canonical URL.

### Usage in Views

```erb
<%= meta_tags(@post) %>
```

### Configuration

```ruby
Blogify.configure do |config|
  config.default_meta_title_format = "%{title} | %{site_name}"
  config.default_meta_description_format = "%{excerpt}"
end
```

### Post-Specific Meta Tags

You can set post-specific meta tags when creating or updating a post:

```ruby
post = Blogify::Post.create(
  title: "My First Blog Post",
  content: "This is the content of my first blog post.",
  meta_title: "Custom Meta Title",
  meta_description: "Custom meta description for SEO purposes"
)
```

If you don't set these values, Blogify will automatically generate them based on the post title and content.

## OpenGraph and Twitter Cards

Blogify generates OpenGraph and Twitter Card meta tags for better social media sharing.

### Usage in Views

```erb
<%= open_graph_tags(@post) %>
<%= twitter_card_tags(@post) %>
```

### Configuration

```ruby
Blogify.configure do |config|
  config.site_name = "My Awesome Blog"
  config.twitter_site = "@myblog"
  config.twitter_creator = "@author"
  config.facebook_app_id = "123456789"
  config.site_logo = "https://example.com/logo.png"
  config.locale = "en"
end
```

## JSON-LD Structured Data

Blogify generates JSON-LD structured data for your blog posts, which helps search engines understand your content better.

### Usage in Views

```erb
<%= json_ld_schema(@post) %>
```

### Configuration

```ruby
Blogify.configure do |config|
  config.schema_org_type = "BlogPosting" # Options: "BlogPosting", "Article", "NewsArticle"
  config.organization_schema = {
    "@type" => "Organization",
    "name" => "My Company",
    "url" => "https://example.com",
    "logo" => "https://example.com/logo.png"
  }
end
```

## Breadcrumb Schema

Blogify can generate breadcrumb schema for your blog posts, which helps search engines understand the structure of your site.

### Usage in Views

```erb
<%= breadcrumb_schema(@post) %>
```

### Configuration

```ruby
Blogify.configure do |config|
  config.breadcrumb_schema_enabled = true
end
```

## Configuration Options

Here's a complete list of SEO-related configuration options:

```ruby
Blogify.configure do |config|
  # SEO Configuration
  config.site_name = "My Awesome Blog"
  config.twitter_site = "@myblog"
  config.twitter_creator = "@author"
  config.facebook_app_id = "123456789"
  config.site_logo = "https://example.com/logo.png"
  config.locale = "en"
  config.blog_title = "Blog"
  config.blog_description = "Latest blog posts"

  # Slug Configuration
  config.slug_format = :date_prefix # Options: :default, :date_prefix, :date_month_prefix, :custom

  # Default SEO Format Strings
  config.default_meta_title_format = "%{title} | %{site_name}"
  config.default_meta_description_format = "%{excerpt}"

  # Schema.org Configuration
  config.schema_org_type = "BlogPosting" # Options: "BlogPosting", "Article", "NewsArticle"
  config.organization_schema = {
    "@type" => "Organization",
    "name" => "My Company",
    "url" => "https://example.com",
    "logo" => "https://example.com/logo.png"
  }
  config.breadcrumb_schema_enabled = true
end
```

## All-in-One Helper

For convenience, Blogify provides an all-in-one helper that includes all SEO tags:

```erb
<%= all_seo_tags(@post) %>
```

This helper includes meta tags, OpenGraph tags, Twitter Card tags, JSON-LD schema, and breadcrumb schema.
