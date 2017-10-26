Rails.application.routes.draw do


  root 'static_pages#home'

  get '/home', to: 'static_pages#home'

  get '/privacy_notice', to: 'static_pages#privacy_notice'

  get '/conditions_of_use', to: 'static_pages#conditions_of_use'

  devise_for :users #, :controllers => {sessions: 'v1/sessions'}

  get '/users', to: 'users#index' 

  get '/users/:id', to: 'users#show', as: :user

  resources :menus, only: [:index, :new, :create] do
    get "delete"
  end

  get '/orders/:id', to: 'orders#show', as: :order

  get '/orders', to: 'orders#index'

  post '/orders', to: 'orders#create'

  get '/all_orders', to: 'orders#all_index'

  namespace :v1 do
    devise_scope :user do
      post '/login', to: 'sessions#create'
      delete '/logout', to: 'sessions#destroy'
    end
    get '/orders', to: 'orders#index'
  end
  
end
