# Featured Images in Blogify

Blogify provides comprehensive support for featured images in blog posts using ActiveStorage. This document explains how to use and configure featured images.

## Table of Contents

- [Featured Images in Blogify](#featured-images-in-blogify)
  - [Table of Contents](#table-of-contents)
  - [Setup](#setup)
  - [Adding Featured Images to Posts](#adding-featured-images-to-posts)
  - [Displaying Featured Images](#displaying-featured-images)
    - [Basic Image Display](#basic-image-display)
    - [Getting the Image URL](#getting-the-image-url)
  - [Responsive Images](#responsive-images)
  - [Configuration Options](#configuration-options)
    - [Image Variants](#image-variants)
  - [Validation](#validation)

## Setup

Before using featured images, make sure you have ActiveStorage set up in your application:

```bash
$ rails active_storage:install
$ rails db:migrate
```

Configure your storage service in `config/storage.yml` and set the active storage service in your environment files.

## Adding Featured Images to Posts

You can attach a featured image to a post using ActiveStorage's `attach` method:

```ruby
post = Blogify::Post.create(
  title: "My First Blog Post",
  content: "This is the content of my first blog post."
)

# Attach a featured image from a file
post.featured_image.attach(io: File.open("path/to/image.jpg"), filename: "image.jpg")

# Attach a featured image from a form
# In your controller:
def update
  @post = Blogify::Post.find(params[:id])
  @post.update(post_params)
  redirect_to @post
end

private

def post_params
  params.require(:post).permit(:title, :content, :featured_image)
end
```

## Displaying Featured Images

Blogify provides several helpers to display featured images in your views:

### Basic Image Display

```erb
<%= featured_image_tag(@post, :medium, class: "img-fluid") %>
```

This helper accepts the following parameters:

- `post`: The Blogify::Post object
- `variant`: The image variant to use (`:thumbnail`, `:medium`, or `:large`)
- `options`: Options to pass to the `image_tag` helper (e.g., `class`, `alt`)
- `default_url`: A default URL to use if no featured image is attached

### Getting the Image URL

If you need just the URL of the featured image:

```erb
<%= featured_image_url(@post, :medium) %>
```

## Responsive Images

Blogify also provides a helper to create responsive images using the HTML5 `<picture>` element:

```erb
<%= featured_image_picture(@post, class: "img-fluid") %>
```

This generates HTML like:

```html
<picture>
  <source srcset="large-image-url.jpg" media="(min-width: 1200px)">
  <source srcset="medium-image-url.jpg" media="(min-width: 768px)">
  <source srcset="thumbnail-image-url.jpg" media="(max-width: 767px)">
  <img src="medium-image-url.jpg" alt="Post Title" class="img-fluid">
</picture>
```

## Configuration Options

You can configure the featured image functionality in the Blogify initializer:

```ruby
Blogify.configure do |config|
  # Featured Image Sizes
  config.featured_image_sizes = {
    thumbnail: { resize_to_limit: [300, 300] },
    medium: { resize_to_limit: [600, 600] },
    large: { resize_to_limit: [1200, 1200] }
  }

  # Maximum File Size
  config.featured_image_max_size = 5 * 1024 * 1024 # 5 MB in bytes

  # Allowed Content Types
  config.featured_image_content_types = ["image/png", "image/jpeg", "image/jpg", "image/gif", "image/webp"]
end
```

### Image Variants

You can define custom image variants by modifying the `featured_image_sizes` configuration. Each variant is defined as a hash with ActiveStorage variant options:

```ruby
config.featured_image_sizes = {
  thumbnail: { resize_to_limit: [300, 300] },
  medium: { resize_to_limit: [600, 600] },
  large: { resize_to_limit: [1200, 1200] },
  custom: { resize_to_fill: [800, 400] }
}
```

Then you can use your custom variant in the helpers:

```erb
<%= featured_image_tag(@post, :custom) %>
```

## Validation

Blogify automatically validates featured images for content type and file size:

```ruby
# Content Type Validation
validate :validate_featured_image_content_type, if: -> { featured_image.attached? }

# File Size Validation
validate :validate_featured_image_size, if: -> { featured_image.attached? }
```

If a validation fails, an error will be added to the post's errors collection:

```ruby
post = Blogify::Post.new(title: "Test")
post.featured_image.attach(io: File.open("path/to/large_file.jpg"), filename: "large_file.jpg")
post.valid? # => false
post.errors.full_messages # => ["Featured image is too large"]
```

You can customize the validation by changing the configuration options:

```ruby
Blogify.configure do |config|
  # Allow larger files
  config.featured_image_max_size = 10 * 1024 * 1024 # 10 MB

  # Allow more content types
  config.featured_image_content_types = ["image/png", "image/jpeg", "image/jpg", "image/gif", "image/webp", "image/svg+xml"]
end
```
