# frozen_string_literal: true

module Blogify
  class PostsController < ApplicationController
    layout "blogify/blog", only: [:index]
    layout "blogify/post", only: [:show]

    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    def index
      @posts = Post.published.ordered
    end

    def show
      @post = find_post

      # Redirect to the canonical URL if accessed by ID instead of slug
      return unless @post.slug.present? && params[:id] != @post.slug

      redirect_to post_path(@post), status: :moved_permanently
      nil
    end

    private

    def find_post
      # Try to find by slug first, then by ID
      post = Post.published.find_by(slug: params[:id])
      post ||= Post.published.find_by(id: params[:id])

      # Raise RecordNotFound if post is nil (not found or draft)
      raise ActiveRecord::RecordNotFound unless post

      post
    end

    def not_found
      render plain: "Not Found", status: :not_found
    end
  end
end
