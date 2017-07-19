Rails.application.routes.draw do


  root 'static_pages#dashboard'

  get '/privacy_notice', to: 'static_pages#privacy_notice'

  get '/conditions_of_use', to: 'static_pages#conditions_of_use'

  get '/dashboard', to: 'static_pages#dashboard'

  get '/dashboard_lunches_admin', to: 'static_pages#dashboard_lunches_admin'

  devise_for :users

  get '/users', to: 'users#index'

  get '/users/:id', to: 'users#show', :as => :user


end
