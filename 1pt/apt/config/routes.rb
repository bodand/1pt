Rails.application.routes.draw do
  resources :event, only: [ :new, :create, :index, :show ] do
    get 'r', to: 'event#respond'
  end

  get 'register', to: "user#register"
  get 'login', to: "user#login"
  get 'user/:id', to: "user#edit"
  get 'api/users', to: "user#api_list"
  get 'logout', to: "user#logout"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
end
