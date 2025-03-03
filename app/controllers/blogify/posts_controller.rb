# frozen_string_literal: true

module Blogify
  class PostsController < ApplicationController
    layout Blogify::Engine.config.blog_layout, only: [:index]
    layout Blogify::Engine.config.post_layout, only: [:show]

    def index
      @posts = Post.all.order(published_at: :desc)
    end

    def show
      @post = Post.find(params[:id])
    end
  end
end
