Rails.application.routes.draw do
  # Signup (user creation)
  post '/signup', to: 'users#create'

  # Signin (login)
  post '/signin', to: 'sessions#create'
  
  #homepage
  namespace :homepage do
    get 'events/featured', to: 'events#featured'
  end 
  
  # Admin section
  namespace :admin do
    get 'stats', to: 'dashboard#stats'

    resources :venues, only: [:index, :show, :create, :update, :destroy]
    resources :users, only: [:index, :destroy]
    resources :organizers, only: [:index, :destroy] 
    resources :events, only: [:index, :destroy]

    get 'organizers', to: 'users#organizers' 
    get 'event_registrations', to: 'users#event_registrations'
  get 'unregistered_users', to: 'users#unregistered_users'    
    delete 'users/:id', to: 'users#destroy' # This line is already handled by resources :users, but okay if needed
  end

  #organizer
  namespace :organizer do
    resources :venues, only: [:index]
    resources :discount_codes, only: [:index, :show, :create, :update, :destroy]
    get 'available_venues', to: 'venues#available'
     get 'event_details/:id', to: 'events#event_details', as: 'event_details'
     resources :events do
      resources :discount_codes, only: [:index, :show, :edit, :update, :destroy]

    end
    resources :events, only: [:index, :show, :create, :update, :destroy] do
      member do
        get 'event_details'  # This maps to /organizer/events/:id/event_details
      end
    end
    resources :discount_codes, only: [:index, :show, :create, :update, :destroy]
    get '/profile', to: 'organizers#profile' 
  end
  
  #attendee
  namespace :attendee do
     get '/profile', to: 'profile#show'
     resources :events, only: [:show]
     resources :discount_codes, only: [:index]
     resources :registrations, only: [:create, :show]
     resources :payments, only: [:show, :update] 
      get 'cart', to: 'registration_carts#index'
     post 'cart', to: 'registration_carts#create'
     resources :registration_carts, only: [:index, :create, :destroy] do
      member do
        patch :confirm # To confirm registration
      end
    end
     resources :attendees, only: [] do
      collection do
        get 'events_grouped_by_category' # Define the route for the event listing
      end
    end
  end
  
end
