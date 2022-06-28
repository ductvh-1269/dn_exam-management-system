Rails.application.routes.draw do
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"
  get "static_pages/home"
  resources :sessions, only: %i(new create destroy)
  get "histories/create"
  root "static_pages#home"
  resources :subjects do
    resources :exams do
    end
  end
  resources :exams
end
