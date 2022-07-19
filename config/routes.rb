Rails.application.routes.draw do
  devise_for :users
  root "static_pages#home"
  get "/search", to: "exams#search", as: :search
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
