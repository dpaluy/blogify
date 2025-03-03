# frozen_string_literal: true

module Blogify
  class Post < ApplicationRecord
    self.table_name = "blogify_posts"

    scope :published, -> { where.not(published_at: nil) }
    scope :draft, -> { where(published_at: nil) }
    scope :ordered, -> { order(published_at: :desc) }
  end
end
