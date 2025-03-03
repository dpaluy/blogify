# Blogify - Rails Engine for Blogs

[![Gem Version](https://badge.fury.io/rb/blogify.svg)](https://badge.fury.io/rb/blogify)
[![CI Status](https://github.com/dpaluy/blogify/actions/workflows/main.yml/badge.svg)](https://github.com/dpaluy/blogify/actions)

Blogify is a powerful Rails engine that provides a complete blogging solution for your Rails application. It includes features for creating, managing, and displaying blog posts with SEO optimization, slug generation, and ActiveStorage integration for featured images.

## Documentation

Comprehensive documentation is available in the [docs](docs) directory:

- [Documentation Index](docs/index.md) - Overview of all documentation
- [Configuration](docs/configuration.md) - Learn about all configuration options
- [SEO Features](docs/seo.md) - Detailed guide to SEO capabilities
- [Featured Images](docs/featured_images.md) - How to use featured images
- [Slug Generation](docs/slug_generation.md) - Customize your URL slugs
- [Social Sharing](docs/social_sharing.md) - Add social sharing buttons

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'blogify'
```

Then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install blogify
```

## Setup

### Mount the Engine

Mount the Blogify engine in your Rails application's `config/routes.rb` file:

```ruby
Rails.application.routes.draw do
  mount Blogify::Engine, at: '/blog'
end
```

### Generate All Components

To generate all Blogify components (config, views, controllers, migration) at once:

```bash
$ rails generate blogify:all
```

### Generate Migration

Generate the database migration:

```bash
$ rails generate blogify:migration
```

By default, this creates a table named `blogify_posts`. You can customize the table name:

```bash
$ rails generate blogify:migration --table-name=custom_posts
```

### Run Migrations

Run the migrations:

```bash
$ rails db:migrate
```

### Generate Configuration

Generate the configuration initializer:

```bash
$ rails generate blogify:config
```

This will create a configuration file at `config/initializers/blogify.rb` with detailed documentation for all available options.

## Features

### SEO Optimization

Blogify includes comprehensive SEO features:

- SEO-friendly URLs with customizable slug formats
- Meta title and description generation
- OpenGraph and Twitter Card meta tags
- JSON-LD structured data for blog posts
- Breadcrumb schema support

### Featured Images

Blogify supports featured images for blog posts using ActiveStorage:

- Multiple image variants (thumbnail, medium, large)
- Configurable image sizes and formats
- Responsive image helpers
- Content type and size validation

### Social Sharing

Easily add social sharing buttons to your blog posts:

- Twitter, Facebook, LinkedIn, Pinterest, and Email sharing
- Configurable button selection
- Customizable appearance

## Usage

### Creating Blog Posts

Once installed, you can create blog posts with:

```ruby
post = Blogify::Post.create(
  title: "My First Blog Post",
  content: "This is the content of my first blog post.",
  meta_description: "A brief description for SEO purposes"
)

# Attach a featured image
post.featured_image.attach(io: File.open("path/to/image.jpg"), filename: "image.jpg")

# Publish the post
post.publish!
```

### Displaying Blog Content

Blogify provides several helpers to display blog content in your views:

```erb
<%# Display SEO meta tags %>
<%= all_seo_tags(@post) %>

<%# Display featured image %>
<%= featured_image_tag(@post, :medium, class: "img-fluid") %>

<%# Display responsive featured image %>
<%= featured_image_picture(@post, class: "img-fluid") %>

<%# Display social sharing buttons %>
<%= social_share_buttons(@post) %>
```

### Customizing Views

Override Blogify views by copying them to your application:

```bash
$ rails generate blogify:views
```

### Customizing Controllers

Generate controllers to customize behavior:

```bash
$ rails generate blogify:controllers
```

## Configuration Options

Blogify can be configured with various options in the initializer. Generate the initializer with:

```bash
$ rails generate blogify:config
```

Then customize the options in `config/initializers/blogify.rb`:

```ruby
Blogify.configure do |config|
  # Layout Configuration
  config.blog_layout = "application"
  config.post_layout = "application"

  # SEO Configuration
  config.site_name = "My Awesome Blog"
  config.twitter_site = "@myblog"
  config.site_logo = "https://example.com/logo.png"
  config.locale = "en"
  config.blog_title = "Blog"
  config.blog_description = "Latest blog posts"

  # Slug Configuration
  # Options: :default, :date_prefix, :date_month_prefix, :custom
  config.slug_format = :date_prefix

  # Featured Image Configuration
  config.featured_image_sizes = {
    thumbnail: { resize_to_limit: [300, 300] },
    medium: { resize_to_limit: [600, 600] },
    large: { resize_to_limit: [1200, 1200] }
  }
  config.featured_image_max_size = 5 * 1024 * 1024 # 5 MB
  config.featured_image_content_types = ["image/png", "image/jpeg", "image/jpg", "image/gif", "image/webp"]

  # Default SEO Format Strings
  config.default_meta_title_format = "%{title} | %{site_name}"
  config.default_meta_description_format = "%{excerpt}"

  # Social Media Configuration
  config.facebook_app_id = "123456789"
  config.twitter_creator = "@author"
  config.social_share_buttons = [:twitter, :facebook, :linkedin]

  # Schema.org Configuration
  config.schema_org_type = "BlogPosting"
  config.breadcrumb_schema_enabled = true

  # Database Configuration
  config.table_name = "blogify_posts" # Default table name
end
```

For a complete list of configuration options and detailed explanations, see the [Configuration Documentation](docs/configuration.md).

### Slug Formats

Blogify supports several slug formats:

- `:default` - Uses the post title (e.g., "my-awesome-post")
- `:date_prefix` - Prefixes the slug with the date (e.g., "2023-01-01-my-awesome-post")
- `:date_month_prefix` - Prefixes the slug with the year and month (e.g., "2023-01-my-awesome-post")
- `:custom` - Uses a custom slug format (requires implementing a custom SlugGenerator)

For more details on slug generation, see the [Slug Generation Documentation](docs/slug_generation.md).

### ActiveStorage Integration

Blogify uses ActiveStorage for handling featured images. Make sure you have ActiveStorage set up in your application:

```bash
$ rails active_storage:install
$ rails db:migrate
```

Configure your storage service in `config/storage.yml` and set the active storage service in your environment files.

For more details on featured images, see the [Featured Images Documentation](docs/featured_images.md).

### Customizing the Database Table

By default, Blogify uses a table named `blogify_posts`. You can customize this in two ways:

1. During migration generation:
   ```bash
   $ rails generate blogify:migration --table-name=custom_posts
   ```

2. In your configuration:
   ```ruby
   Blogify.configure do |config|
     config.table_name = "custom_posts"
   end
   ```

Make sure to set the table name in your configuration before running any database operations.

## Testing

Blogify includes a comprehensive test suite using RSpec. To run the tests:

```bash
$ cd spec/dummy
$ rails db:migrate RAILS_ENV=test
$ bundle exec rspec
```

### Writing Your Own Tests

When testing your application with Blogify, you can use the provided factories:

```ruby
# spec/factories/blogify_factories.rb
FactoryBot.define do
  factory :blogify_post, class: 'Blogify::Post' do
    title { "Test Post" }
    content { "Test Content" }
    status { :published }
  end
end
```

## To Do

Here are planned improvements and features for future releases:

- [ ] Add support for post categories and tags
- [ ] Implement comment system with moderation
- [ ] Create admin dashboard for blog management
- [ ] Add support for multiple authors
- [ ] Implement RSS/Atom feed generation
- [ ] Add post scheduling functionality
- [ ] Improve SEO features with XML sitemap generation
- [ ] Implement analytics integration
- [ ] Add support for post series/collections

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
