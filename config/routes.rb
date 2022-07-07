Rails.application.routes.draw do
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  root "static_pages#home"
  get "/search", to: "exams#search", as: :search
  resources :sessions, only: %i(new create destroy)
  resources :subjects, only: %i(index show)
  resources :exams
  namespace :admin do
    resources :subjects, only: %i(new create destroy) do
      member do
        get :export
      end
      resources :questions
    end
    resources :exams, only: %i(index show)
    get "/search", to: "exams#search", as: :search
  end
  resources :subjects do
    resources :exams do
    end
  end
  resources :exams, only: %i(update new)
end
