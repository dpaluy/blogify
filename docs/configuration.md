# Configuration System in Blogify

Blogify provides a flexible configuration system that allows you to customize various aspects of the engine. This document explains how to use and configure Blogify to suit your needs.

## Table of Contents

1. [Generating the Configuration File](#generating-the-configuration-file)
2. [Configuration Options](#configuration-options)
3. [Custom Configuration](#custom-configuration)
4. [Configuration API](#configuration-api)
5. [Validation](#validation)

## Generating the Configuration File

Blogify provides a generator to create a configuration initializer file with all available options and documentation:

```bash
$ rails generate blogify:config
```

This will create a file at `config/initializers/blogify.rb` with all available configuration options and their default values, along with documentation for each option.

## Configuration Options

The configuration file is organized into sections for different aspects of the Blogify engine:

### General Configuration

```ruby
Blogify.configure do |config|
  # The layout to be used by the Blogify engine
  config.layout = 'application'

  # Number of posts to display per page
  config.posts_per_page = 10

  # Default status for new posts (draft or published)
  config.default_post_status = :draft
end
```

### SEO Configuration

```ruby
Blogify.configure do |config|
  # Default meta title format for blog posts
  # Available variables: :title, :site_name
  config.meta_title_format = ':title | :site_name'

  # Default meta description format for blog posts
  # Available variables: :excerpt, :title
  config.meta_description_format = ':excerpt'

  # Site name for OpenGraph tags
  config.site_name = 'My Awesome Blog'

  # Twitter handle (without @)
  config.twitter_site = 'myblog'

  # Facebook App ID
  config.facebook_app_id = nil

  # Schema.org type for blog posts
  # Options: BlogPosting, Article, NewsArticle
  config.schema_org_type = 'BlogPosting'

  # Enable breadcrumb schema
  config.enable_breadcrumb_schema = true

  # Organization schema details
  config.organization_schema = {
    name: 'My Company',
    url: 'https://example.com',
    logo: 'https://example.com/logo.png'
  }
end
```

### Slug Configuration

```ruby
Blogify.configure do |config|
  # Slug format for blog posts
  # Options: :default, :date_prefix, :date_month_prefix, or a custom proc
  config.slug_format = :default

  # Custom slug generator class
  # Must inherit from Blogify::SlugGenerator
  config.slug_generator = nil
end
```

### Featured Image Configuration

```ruby
Blogify.configure do |config|
  # Featured image sizes for different variants
  config.featured_image_sizes = {
    thumbnail: { resize_to_limit: [300, 300] },
    medium: { resize_to_limit: [600, 600] },
    large: { resize_to_limit: [1200, 1200] }
  }

  # Maximum file size for featured images (in bytes)
  config.featured_image_max_size = 5 * 1024 * 1024 # 5 MB

  # Allowed content types for featured images
  config.featured_image_content_types = [
    "image/png", "image/jpeg", "image/jpg", "image/gif", "image/webp"
  ]
end
```

### Social Sharing Configuration

```ruby
Blogify.configure do |config|
  # Enable social sharing buttons
  config.enable_social_sharing = true

  # Social networks to include in sharing buttons
  config.social_share_buttons = [:twitter, :facebook, :linkedin]
end
```

## Custom Configuration

You can add your own custom configuration options by extending the Blogify configuration class:

```ruby
# config/initializers/blogify_extensions.rb
module Blogify
  class Configuration
    # Add a new configuration option with a default value
    attr_accessor :my_custom_option

    # Set a default value in the reset method
    alias_method :original_reset, :reset

    def reset
      original_reset
      @my_custom_option = 'default value'
    end
  end
end
```

Then you can use your custom option in the configuration:

```ruby
# config/initializers/blogify.rb
Blogify.configure do |config|
  config.my_custom_option = 'custom value'
end
```

## Configuration API

Blogify provides a simple API to access configuration values:

```ruby
# Access configuration values
Blogify.config.posts_per_page # => 10
Blogify.config.layout # => 'application'

# Check if a feature is enabled
if Blogify.config.enable_social_sharing
  # Render social sharing buttons
end

# Use configuration values in your code
def meta_title
  format = Blogify.config.meta_title_format
  format.gsub(':title', @post.title)
        .gsub(':site_name', Blogify.config.site_name)
end
```

## Validation

The configuration system includes validation to ensure that your configuration values are valid:

```ruby
# Invalid configuration
Blogify.configure do |config|
  config.posts_per_page = 'invalid' # Should be an integer
end

# This will raise an error:
# Blogify::ConfigurationError: posts_per_page must be an integer
```

### Available Validations

- Type validations (integer, string, symbol, boolean, hash, array, proc)
- Inclusion validations (value must be in a list of allowed values)
- Custom validations (using a proc)

### Custom Validations

You can add custom validations to your configuration options:

```ruby
# config/initializers/blogify_extensions.rb
module Blogify
  class Configuration
    # Add a new configuration option with validation
    attr_accessor :api_key

    alias_method :original_validate, :validate

    def validate
      original_validate

      # Validate that api_key is present
      if @api_key.nil? || @api_key.empty?
        raise Blogify::ConfigurationError, "api_key cannot be blank"
      end
    end
  end
end
```

## Example: Complete Configuration

Here's an example of a complete configuration file:

```ruby
Blogify.configure do |config|
  # General Configuration
  config.layout = 'blog'
  config.posts_per_page = 5
  config.default_post_status = :draft

  # SEO Configuration
  config.meta_title_format = ':title | My Awesome Blog'
  config.meta_description_format = ':excerpt'
  config.site_name = 'My Awesome Blog'
  config.twitter_site = 'myblog'
  config.facebook_app_id = '123456789'
  config.schema_org_type = 'BlogPosting'
  config.enable_breadcrumb_schema = true
  config.organization_schema = {
    name: 'My Company',
    url: 'https://example.com',
    logo: 'https://example.com/logo.png'
  }

  # Slug Configuration
  config.slug_format = :date_prefix

  # Featured Image Configuration
  config.featured_image_sizes = {
    thumbnail: { resize_to_limit: [300, 300] },
    medium: { resize_to_limit: [600, 600] },
    large: { resize_to_limit: [1200, 1200] },
    hero: { resize_to_fill: [1600, 800] }
  }
  config.featured_image_max_size = 10 * 1024 * 1024 # 10 MB
  config.featured_image_content_types = [
    "image/png", "image/jpeg", "image/jpg", "image/gif", "image/webp"
  ]

  # Social Sharing Configuration
  config.enable_social_sharing = true
  config.social_share_buttons = [:twitter, :facebook, :linkedin, :pinterest]
end
