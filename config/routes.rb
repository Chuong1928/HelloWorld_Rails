Rails.application.routes.draw do
  
  get 'password_resets/new'
  get 'password_resets/edit'
  # get 'errors/not_found'
  # get 'errors/internal_server_error'
  
  resources :microposts
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  get "/" => "microposts#index"
  get "sign_up" => "register#new"
  post "sign_up" => "register#create"

  get '/login',to: 'sessions#new'
  post "/login" => "sessions#create"
  delete "/logout" => "sessions#destroy"


  match "/404", to: 'errors#not_found', via: :all
  match "/422", to: 'errors#unprocessable', via: :all
  match "/500", to: 'errors#internal_server_error', via: :all
  
  root 'users#index'
 
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
