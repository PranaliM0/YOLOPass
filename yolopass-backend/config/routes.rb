Rails.application.routes.draw do
  # Signup (user creation)
  post '/signup', to: 'users#create'

  # Signin (login)
  post '/signin', to: 'sessions#create'
  
  # adminstat
  namespace :admin do
    get 'stats', to: 'dashboard#stats'
  end

  # adminuser
  namespace :admin do
    resources :users, only: [:index, :destroy]
    resources :events, only: [:index, :destroy]
    get 'organizers', to: 'users#organizers'     
    delete 'users/:id', to: 'users#destroy'
  end

  namespace :organizer do
    resources :events, only: [:index, :show, :create, :update, :destroy]
    get '/profile', to: 'organizers#profile' 
  end
  
end
