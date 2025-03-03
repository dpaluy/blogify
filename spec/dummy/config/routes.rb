# frozen_string_literal: true

Rails.application.routes.draw do
  mount Blogify::Engine => "/blog"

  root to: "blogify/posts#index"
end
