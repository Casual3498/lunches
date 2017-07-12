Rails.application.routes.draw do

  root 'static_pages#dashboard'

  get 'static_pages/dashboard'

  get 'static_pages/dashboard_lunches_admin'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
