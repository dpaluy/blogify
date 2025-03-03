# Social Sharing in Blogify

Blogify provides built-in support for social sharing buttons to help readers share your blog posts on various social media platforms. This document explains how to use and configure the social sharing functionality.

## Table of Contents

1. [Overview](#overview)
2. [Available Social Networks](#available-social-networks)
3. [Configuration](#configuration)
4. [Usage in Views](#usage-in-views)
5. [Customizing the Appearance](#customizing-the-appearance)
6. [Adding Custom Social Networks](#adding-custom-social-networks)

## Overview

Social sharing buttons allow readers to easily share your blog posts on social media platforms like Twitter, Facebook, LinkedIn, and more. Blogify provides a simple way to add these buttons to your blog posts.

## Available Social Networks

Blogify supports the following social networks out of the box:

- Twitter
- Facebook
- LinkedIn
- Pinterest
- Reddit
- Email

## Configuration

Configure social sharing in your Blogify initializer:

```ruby
Blogify.configure do |config|
  # Enable or disable social sharing buttons
  config.enable_social_sharing = true

  # Specify which social networks to include
  config.social_share_buttons = [:twitter, :facebook, :linkedin]
end
```

### Configuration Options

- `enable_social_sharing`: Boolean to enable or disable social sharing buttons (default: `true`)
- `social_share_buttons`: Array of symbols representing the social networks to include (default: `[:twitter, :facebook, :linkedin]`)

## Usage in Views

To display social sharing buttons in your views, use the `social_share_buttons` helper:

```erb
<%= social_share_buttons(@post) %>
```

This will generate HTML for the social sharing buttons based on your configuration.

### Example Output

```html
<div class="blogify-social-share">
  <a href="https://twitter.com/intent/tweet?url=https://example.com/blog/my-post&text=My Post Title" target="_blank" class="blogify-social-button blogify-twitter-button">
    <i class="blogify-icon-twitter"></i> Twitter
  </a>
  <a href="https://www.facebook.com/sharer/sharer.php?u=https://example.com/blog/my-post" target="_blank" class="blogify-social-button blogify-facebook-button">
    <i class="blogify-icon-facebook"></i> Facebook
  </a>
  <a href="https://www.linkedin.com/shareArticle?mini=true&url=https://example.com/blog/my-post&title=My Post Title" target="_blank" class="blogify-social-button blogify-linkedin-button">
    <i class="blogify-icon-linkedin"></i> LinkedIn
  </a>
</div>
```

### Helper Options

The `social_share_buttons` helper accepts the following options:

```erb
<%= social_share_buttons(@post,
                         networks: [:twitter, :facebook],
                         class: "my-custom-class",
                         show_labels: false) %>
```

- `networks`: Override the configured social networks for this specific instance
- `class`: Add custom CSS classes to the container
- `show_labels`: Boolean to show or hide the text labels (default: `true`)

## Customizing the Appearance

### Basic Styling

Blogify provides basic styling for social sharing buttons. You can customize the appearance by adding your own CSS:

```css
/* Custom styles for social sharing buttons */
.blogify-social-share {
  display: flex;
  gap: 10px;
  margin: 20px 0;
}

.blogify-social-button {
  display: inline-flex;
  align-items: center;
  padding: 8px 12px;
  border-radius: 4px;
  color: white;
  text-decoration: none;
  font-size: 14px;
}

.blogify-twitter-button {
  background-color: #1DA1F2;
}

.blogify-facebook-button {
  background-color: #4267B2;
}

.blogify-linkedin-button {
  background-color: #0077B5;
}

.blogify-pinterest-button {
  background-color: #E60023;
}

.blogify-reddit-button {
  background-color: #FF4500;
}

.blogify-email-button {
  background-color: #333333;
}
```

### Using Icons

You can use icon libraries like Font Awesome or Material Icons with the social sharing buttons:

```erb
<!-- In your layout file -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
```

Then customize the helper to use these icons:

```ruby
# app/helpers/application_helper.rb
module ApplicationHelper
  def custom_social_share_buttons(post)
    render partial: 'shared/social_buttons', locals: { post: post }
  end
end
```

```erb
<!-- app/views/shared/_social_buttons.html.erb -->
<div class="social-share-buttons">
  <a href="https://twitter.com/intent/tweet?url=<%= post_url(post) %>&text=<%= post.title %>" target="_blank" class="btn btn-twitter">
    <i class="fab fa-twitter"></i> Tweet
  </a>
  <a href="https://www.facebook.com/sharer/sharer.php?u=<%= post_url(post) %>" target="_blank" class="btn btn-facebook">
    <i class="fab fa-facebook-f"></i> Share
  </a>
  <!-- Add more buttons as needed -->
</div>
```

## Adding Custom Social Networks

You can add support for additional social networks by extending the SEO helper:

```ruby
# config/initializers/blogify_extensions.rb
module Blogify
  module SeoHelper
    def social_share_buttons(post, options = {})
      networks = options[:networks] || Blogify.config.social_share_buttons

      # Call the original method
      original_buttons = super(post, options)

      # If our custom network is not in the configured networks, return the original buttons
      return original_buttons unless networks.include?(:whatsapp)

      # Get the container element
      container = Nokogiri::HTML::DocumentFragment.parse(original_buttons)

      # Add our custom button
      whatsapp_url = "https://api.whatsapp.com/send?text=#{CGI.escape(post.title)} #{CGI.escape(post_url(post))}"
      whatsapp_button = %Q{
        <a href="#{whatsapp_url}" target="_blank" class="blogify-social-button blogify-whatsapp-button">
          <i class="blogify-icon-whatsapp"></i> WhatsApp
        </a>
      }

      container.at_css('.blogify-social-share').add_child(whatsapp_button)

      # Return the modified HTML
      container.to_html.html_safe
    end
  end
end
```

Then add the new network to your configuration:

```ruby
Blogify.configure do |config|
  config.social_share_buttons = [:twitter, :facebook, :linkedin, :whatsapp]
end
```

### Example: Adding WhatsApp Sharing

```ruby
# app/helpers/application_helper.rb
module ApplicationHelper
  def whatsapp_share_url(post)
    text = "#{post.title} #{post_url(post)}"
    "https://api.whatsapp.com/send?text=#{CGI.escape(text)}"
  end
end
```

```erb
<!-- In your view -->
<div class="social-share-buttons">
  <%= social_share_buttons(@post) %>
  <a href="<%= whatsapp_share_url(@post) %>" target="_blank" class="blogify-social-button blogify-whatsapp-button">
    <i class="fab fa-whatsapp"></i> WhatsApp
  </a>
</div>
```

## Advanced: Creating a Custom Social Sharing Component

For more advanced customization, you can create your own social sharing component:

```ruby
# app/components/social_share_component.rb
class SocialShareComponent < ViewComponent::Base
  def initialize(post:, networks: nil)
    @post = post
    @networks = networks || Blogify.config.social_share_buttons
  end

  def share_urls
    {
      twitter: "https://twitter.com/intent/tweet?url=#{CGI.escape(post_url(@post))}&text=#{CGI.escape(@post.title)}",
      facebook: "https://www.facebook.com/sharer/sharer.php?u=#{CGI.escape(post_url(@post))}",
      linkedin: "https://www.linkedin.com/shareArticle?mini=true&url=#{CGI.escape(post_url(@post))}&title=#{CGI.escape(@post.title)}",
      pinterest: "https://pinterest.com/pin/create/button/?url=#{CGI.escape(post_url(@post))}&media=#{CGI.escape(featured_image_url(@post, :large))}&description=#{CGI.escape(@post.title)}",
      reddit: "https://www.reddit.com/submit?url=#{CGI.escape(post_url(@post))}&title=#{CGI.escape(@post.title)}",
      email: "mailto:?subject=#{CGI.escape(@post.title)}&body=#{CGI.escape("Check out this post: #{post_url(@post)}")}"
    }
  end

  def network_names
    {
      twitter: "Twitter",
      facebook: "Facebook",
      linkedin: "LinkedIn",
      pinterest: "Pinterest",
      reddit: "Reddit",
      email: "Email"
    }
  end

  def network_icons
    {
      twitter: "fab fa-twitter",
      facebook: "fab fa-facebook-f",
      linkedin: "fab fa-linkedin-in",
      pinterest: "fab fa-pinterest-p",
      reddit: "fab fa-reddit-alien",
      email: "fas fa-envelope"
    }
  end
end
```

```erb
<!-- app/components/social_share_component.html.erb -->
<div class="social-share-buttons">
  <% @networks.each do |network| %>
    <a href="<%= share_urls[network] %>" target="_blank" class="social-button <%= network %>-button">
      <i class="<%= network_icons[network] %>"></i>
      <span class="network-name"><%= network_names[network] %></span>
    </a>
  <% end %>
</div>
```

Then use the component in your views:

```erb
<%= render(SocialShareComponent.new(post: @post)) %>
```
