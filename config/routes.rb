# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'merchants#index'

  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout

  resources :merchants
  resources :sessions, only: %i[new create destroy]

  namespace :api do
    namespace :v1 do
      resources :transactions, only: %i[create], defaults: { format: %i[json xml] }
    end
  end
end
