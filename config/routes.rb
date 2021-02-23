# frozen_string_literal: true

Spree::Core::Engine.routes.draw do
  resources :products, only: [] do
    resources :reviews, only: %i[new create]
  end
end
