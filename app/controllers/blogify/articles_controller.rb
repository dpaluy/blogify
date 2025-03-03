# frozen_string_literal: true

module Blogify
  class ArticlesController < ApplicationController
    layout Blogify::Engine.config.blog_layout, only: [:index]
    layout Blogify::Engine.config.article_layout, only: [:show]

    def index
      @articles = Article.all.order(published_at: :desc)
    end

    def show
      @article = Article.find(params[:id])
    end
  end
end
