Rails.application.routes.draw do
  
  # get 'errors/not_found'
  # get 'errors/internal_server_error'
  
  resources :microposts
  resources :users
  get "/" => "users#index"
  get "sign_up" => "session#new"
  post "sign_up" => "session#create"

  match "/404", to: 'errors#not_found', via: :all
  match "/422", to: 'errors#unprocessable', via: :all
  match "/500", to: 'errors#internal_server_error', via: :all
  
  root 'users#index'
 
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
