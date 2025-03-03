# frozen_string_literal: true

Blogify::Engine.routes.draw do
  root to: "posts#index"
  resources :posts, only: [:index, :show]
end
