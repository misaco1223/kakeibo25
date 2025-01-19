Rails.application.routes.draw do
  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :sessions, only: %i[new create destroy]
  resources :users, only: %i[index show new create edit update destroy]
  resources :money_files, only: %i[index show new create edit update destroy]
  resources :budgets do
    resources :payments, only: %i[index show new create edit update destroy]
  end
  resources :categories, only: %i[index show new create edit update destroy]
  resources :shops, only: %i[index show new create edit update destroy]
  resources :pay_methods, only: %i[index show new create edit update destroy]
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  get "/" => "money_files#index"
  # root "posts#index"

  get "login" => "sessions#new", as: :login
  get "logout" => "sessions#destroy", as: :logout

  post 'guest_login', to: 'sessions#guest_login', as: :guest_login
end
