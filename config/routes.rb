Rails.application.routes.draw do
  devise_for :admins
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # get "/users", to: "users#index"
  # get "/users/:id", to: "users#show"
  
  root "users#index"

  resources :users

  post "/uploads" , to: "users#upload"


  devise_for :users, controllers: { sessions: 'users/sessions' }


end
