Rails.application.routes.draw do


  root 'static_pages#home'

  get '/home', to: 'static_pages#home'

  get '/privacy_notice', to: 'static_pages#privacy_notice'

  get '/conditions_of_use', to: 'static_pages#conditions_of_use'

  devise_for :users

  get '/users', to: 'users#index' 

  get '/users/:id', to: 'users#show', as: :user

  resources :menus do
    get "delete"
  end

  get '/orders/:id', to: 'orders#show', as: :order

  get '/orders', to: 'orders#index'

  post '/orders', to: 'orders#create'

  get '/all_orders', to: 'orders#all_index'

  namespace :v1 do
    get '/orders', to: 'orders#index'
    resources :sessions, only: [:create, :destroy]
  end
  
end
