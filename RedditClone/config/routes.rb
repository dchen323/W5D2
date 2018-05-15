Rails.application.routes.draw do
  
  get 'subs/index'
  get 'subs/show'
  get 'subs/new'
  get 'subs/edit'
  resources :users, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]
  
  
  resources :subs, except: [:destroy]
  
  root 'subs#index'
  
end
