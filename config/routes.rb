# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  get 'initrax', to: 'home#initrax', as: :initrax
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  devise_scope :user do
    scope :users, as: :users do
      post 'pre_otp', to: 'users/sessions#pre_otp'
      get '/', to: 'users/registrations#show'
      get '/otp', to: 'users/otp#index', as: 'otp_index'
      put '/otp', to: 'users/otp#update', as: 'otp_update'
      get '/otp/qrcode', to: 'users/otp#qrcode', as: 'otp_qrcode'
      get '/otp/backup_codes', to: 'users/otp#backup_codes', as: 'otp_backup_codes'
    end
  end

  namespace :api do
    post '/characters/order', to: 'characters#order'
    post '/combatants/order', to: 'combatants#order'
    get '/combats/names', to: 'combats#names'

    resources :characters, only: %i[index show create update destroy], defaults: { format: 'json' }
    resources :combats, only: %i[index show create update destroy], defaults: { format: 'json' }
    resources :combatants, only: %i[update destroy], defaults: { format: 'json' }
  end
end
