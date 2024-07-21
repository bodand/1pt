Rails.application.routes.draw do
  resources :events, only: [:new, :create, :index, :show] do
    get 'r', to: 'events#get_responses', as: :responses
  end
  post 'events/find', to: 'events#find_event', as: :find_events
  post 'events/:id/fill', to: 'events#save_response', as: :event_fill

  get 'register', to: "users#register", as: :register
  get 'login', to: "users#login", as: :login

  post 'users/create', to: "users#create", as: :user_create
  get 'users/:id', to: "users#edit", as: :user_edit
  patch 'users/:id', to: "users#update", as: :update_user
  patch 'users/:id/passwd', to: "users#update_password", as: :update_user_passwd

  post 'sessions/login', to: "sessions#login", as: :session_login
  get 'sessions/logout', to: "sessions#logout", as: :session_logout

  get 'api/users', to: "users#api_list", as: :users_list
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index", as: :root_page
end
