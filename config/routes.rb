Rails.application.routes.draw do
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  root "static_pages#home"
  get "static_pages/home"
  resources :sessions, only: %i(new create destroy)
  resources :subjects, only: %i(index show)
  resources :exams
  namespace :admin do
    resources :subjects, only: %i(new create)
    resources :exams, only: %i(index show)
  end
  resources :subjects do
    resources :exams do
    end
  end
  resources :exams, only: %i(update new show)
end
