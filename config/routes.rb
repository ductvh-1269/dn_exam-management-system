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
      resources :questions do
        collection do
          get "/import", to: "subjects#new_import", as: "import"
          post "/import", to: "subjects#create_import", as: "create_import"
        end
      end
    end
    resources :exams, only: %i(index show)
    get "/search", to: "exams#search", as: :search
    resources :exams, only: %i(index show)
  end
  resources :subjects do
    resources :exams do
    end
  end
  resources :exams, only: %i(update new)
end
