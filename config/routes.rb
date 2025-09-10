Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    resources :restaurants do
      resources :menus do
        # Menu-scoped items
        resources :menu_items
      end
      # Restaurant-scoped items
      resources :menu_items, only: [ :index, :show, :create ]
    end
    # Route for Restaurant Importer Tool (:new used for web view at 'http://localhost:3001/api/imports/new')
    resources :imports, only: [ :create, :new ]
  end

  # Global fallback routes (mainly for Level 1 / debugging)
  resources :menus, only: [ :index, :show ]
  resources :menu_items, only: [ :index, :show ]
end
