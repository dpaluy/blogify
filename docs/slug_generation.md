# Slug Generation in Blogify

Blogify provides flexible slug generation for blog posts to create SEO-friendly URLs. This document explains how to use and configure the slug generation functionality.

## Table of Contents

1. [Overview](#overview)
2. [Available Slug Formats](#available-slug-formats)
3. [Custom Slug Formats](#custom-slug-formats)
4. [Configuration](#configuration)
5. [Customizing Slug Generation](#customizing-slug-generation)

## Overview

Slugs are URL-friendly versions of a post's title, used to create readable and SEO-friendly URLs. Blogify automatically generates slugs for posts based on their titles and the configured slug format.

For example, a post titled "My First Blog Post" might have a slug like:
- `my-first-blog-post` (default format)
- `2023-05-15-my-first-blog-post` (date prefix format)
- `2023-05-my-first-blog-post` (date month prefix format)

## Available Slug Formats

Blogify provides several built-in slug formats:

### Default Format (`:default`)

The default format simply converts the post title to a URL-friendly string:

```
my-first-blog-post
```

### Date Prefix Format (`:date_prefix`)

This format prefixes the slug with the post's publication date in `YYYY-MM-DD` format:

```
2023-05-15-my-first-blog-post
```

### Date Month Prefix Format (`:date_month_prefix`)

This format prefixes the slug with the post's publication year and month in `YYYY-MM` format:

```
2023-05-my-first-blog-post
```

## Custom Slug Formats

You can define a custom slug format by providing a proc or lambda to the `slug_format` configuration option:

```ruby
Blogify.configure do |config|
  config.slug_format = ->(post) {
    prefix = post.published? ? "published" : "draft"
    "#{prefix}-#{post.title.parameterize}"
  }
end
```

This would generate slugs like:
```
published-my-first-blog-post
draft-my-upcoming-post
```

## Configuration

Configure the slug generation in your Blogify initializer:

```ruby
Blogify.configure do |config|
  # Use one of the built-in formats
  config.slug_format = :date_prefix

  # Or define a custom format
  config.slug_format = ->(post) {
    "#{post.id}-#{post.title.parameterize}"
  }
end
```

## Customizing Slug Generation

### Creating a Custom Slug Generator

For more advanced customization, you can create your own slug generator class:

1. Create a new class that inherits from `Blogify::SlugGenerator`:

```ruby
# app/services/my_custom_slug_generator.rb
class MyCustomSlugGenerator < Blogify::SlugGenerator
  def generate
    # Your custom slug generation logic
    "custom-#{@post.title.parameterize}"
  end
end
```

2. Configure Blogify to use your custom generator:

```ruby
Blogify.configure do |config|
  config.slug_generator = MyCustomSlugGenerator
end
```

### Slug Uniqueness

Blogify automatically ensures that slugs are unique by appending a numeric suffix if necessary:

```
my-first-blog-post
my-first-blog-post-1
my-first-blog-post-2
```

### Regenerating Slugs

By default, slugs are only generated when a post is created. If you want to regenerate a slug for an existing post:

```ruby
post = Blogify::Post.find(1)
post.regenerate_slug!
post.save
```

### Slug Persistence

Once a slug is generated and the post is saved, the slug is persisted in the database. This ensures that URLs remain stable even if the post title changes.

If you want to update the slug when the title changes, you can add a callback to your post model:

```ruby
# In a Rails initializer or custom model
Blogify::Post.class_eval do
  before_save :regenerate_slug_if_title_changed

  private

  def regenerate_slug_if_title_changed
    regenerate_slug! if title_changed?
  end
end
```

## Examples

### Basic Usage

```ruby
# Create a post (slug is automatically generated)
post = Blogify::Post.create(title: "My First Blog Post", content: "Content here...")

# Access the slug
puts post.slug # => "my-first-blog-post"

# Use the slug in URLs
link_to post.title, blogify.post_path(post.slug)
```

### Custom Slug Format Based on Categories

```ruby
Blogify.configure do |config|
  config.slug_format = ->(post) {
    category = post.category&.name&.parameterize || "uncategorized"
    "#{category}/#{post.title.parameterize}"
  }
end
```

This would generate slugs like:
```
technology/my-tech-post
lifestyle/my-lifestyle-post
```

### Localized Slugs

```ruby
Blogify.configure do |config|
  config.slug_format = ->(post) {
    locale = I18n.locale
    "#{locale}/#{post.title.parameterize}"
  }
end
```

This would generate slugs like:
```
en/my-english-post
fr/mon-post-en-francais
```
