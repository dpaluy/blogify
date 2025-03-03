# frozen_string_literal: true

Blogify::Engine.routes.draw do
  root to: "articles#index"
  resources :articles, only: [:index, :show]
end
