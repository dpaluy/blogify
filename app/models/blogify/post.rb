# frozen_string_literal: true

module Blogify
  class Post < ApplicationRecord
    self.table_name = Blogify.config.table_name

    # ActiveStorage
    has_one_attached :featured_image

    # Validations
    validates :title, presence: true
    validates :slug, uniqueness: true, allow_blank: true
    validate :validate_featured_image_content_type, if: -> { featured_image.attached? }
    validate :validate_featured_image_size, if: -> { featured_image.attached? }

    # Callbacks
    before_validation :generate_slug, if: -> { slug.blank? && title.present? }
    before_save :set_meta_title, if: -> { meta_title.blank? && title.present? }
    before_save :set_meta_description, if: -> { meta_description.blank? && content.present? }

    # Scopes
    scope :published, -> { where.not(published_at: nil) }
    scope :draft, -> { where(published_at: nil) }
    scope :ordered, -> { order(published_at: :desc) }

    # Instance methods
    def publish!
      self.published_at = Time.current
      regenerate_slug if Blogify.config.slug_format != :default
      save
    end

    def unpublish!
      self.published_at = nil
      save
    end

    def published?
      published_at.present?
    end

    def to_param
      slug.presence || id.to_s
    end

    def regenerate_slug
      self.slug = generate_slug_string
    end

    def excerpt(length = 160)
      return "" unless content.present?

      # Strip HTML tags and truncate to the specified length
      ActionController::Base.helpers.strip_tags(content).truncate(length)
    end

    private

    def validate_featured_image_content_type
      allowed_types = Blogify.config.featured_image_content_types

      return if allowed_types.include?(featured_image.content_type)

      errors.add(:featured_image, "must be a valid image format")
    end

    def validate_featured_image_size
      max_size = Blogify.config.featured_image_max_size

      return unless featured_image.blob.byte_size > max_size

      errors.add(:featured_image, "is too large")
    end

    def generate_slug
      self.slug = generate_slug_string
    end

    def generate_slug_string
      SlugGenerator.new(self).generate
    end

    def set_meta_title
      format = Blogify.config.default_meta_title_format
      self.meta_title = format(format, title: title, site_name: Blogify.config.site_name)
    end

    def set_meta_description
      format = Blogify.config.default_meta_description_format
      self.meta_description = format(format, excerpt: excerpt)
    end
  end
end
