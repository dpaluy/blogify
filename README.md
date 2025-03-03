# Blogify - Rails Engine for Blogs

[![Gem Version](https://badge.fury.io/rb/blogify.svg)](https://badge.fury.io/rb/blogify)
[![CI Status](https://github.com/dpaluy/blogify/actions/workflows/main.yml/badge.svg)](https://github.com/dpaluy/blogify/actions)

Blogify is a powerful Rails engine that provides a complete blogging solution for your Rails application. It includes features for creating, managing, and displaying blog posts with categories, tags, and comments.

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

### Run Migrations

Copy and run the migrations:

```bash
$ rails blogify:install:migrations
$ rails db:migrate
```

### Configure Authentication (Optional)

Blogify can integrate with your existing authentication system. Create an initializer at `config/initializers/blogify.rb`:

```ruby
Blogify.setup do |config|
  # User class name
  config.user_class = 'User'

  # Method to check if user can manage blog
  config.admin_check_method = :admin?

  # Current user method
  config.current_user_method = :current_user
end
```

## Usage

### Creating Blog Posts

Once installed, navigate to `/blog/admin` to access the admin interface. Here you can:

- Create, edit, and delete blog posts
- Manage categories and tags
- Moderate comments

### Displaying Blog Content

Blogify provides several helpers to display blog content in your views:

```erb
<%# Display recent posts %>
<%= blogify_recent_posts(5) %>

<%# Display posts by category %>
<%= blogify_category_posts('technology') %>

<%# Display post tags %>
<%= blogify_post_tags(@post) %>
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
    title { "Sample Post" }
    content { "This is a sample post content." }
    published { true }
    # associations as needed
  end
end
```

Example test:

```ruby
require 'rails_helper'

RSpec.describe "Blog Posts", type: :request do
  it "displays the index page" do
    create(:blogify_post, title: "Test Post")

    get "/blog"

    expect(response).to have_http_status(:success)
    expect(response.body).to include("Test Post")
  end
end
```

## Configuration Options

Blogify can be configured with various options in the initializer:

```ruby
Blogify.setup do |config|
  # Posts per page in listings
  config.posts_per_page = 10

  # Enable/disable comments
  config.enable_comments = true

  # Moderation settings
  config.moderate_comments = true

  # SEO settings
  config.seo_title_suffix = " | My Awesome Blog"

  # Storage configuration for images
  config.storage = :active_storage
end
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
