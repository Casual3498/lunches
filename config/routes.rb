Rails.application.routes.draw do


  root 'static_pages#home'

  
  #get '/menus', to: 'menus#index'

  #get 'menus/:id', to: 'menus#show', :as => :menu

  get '/home', to: 'static_pages#home'

  get '/privacy_notice', to: 'static_pages#privacy_notice'

  get '/conditions_of_use', to: 'static_pages#conditions_of_use'

  get '/dashboard', to: 'static_pages#dashboard'

  get '/dashboard_lunches_admin', to: 'static_pages#dashboard_lunches_admin'

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


  
end
