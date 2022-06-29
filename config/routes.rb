Rails.application.routes.draw do
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"
  root "static_pages#home"
  get "static_pages/home"
  resources :sessions, only: %i(new create destroy)
end
