Rails.application.routes.draw do

  get '/menus', to: 'menu#index'

  get '/home', to: 'static_pages#home'

  get '/privacy_notice', to: 'static_pages#privacy_notice'

  get '/conditions_of_use', to: 'static_pages#conditions_of_use'

  get '/dashboard', to: 'static_pages#dashboard'

  get '/dashboard_lunches_admin', to: 'static_pages#dashboard_lunches_admin'

  devise_for :users

  get '/users', to: 'users#index'

  get '/users/:id', to: 'users#show', :as => :user

  root 'static_pages#home'

end
