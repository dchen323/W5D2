Rails.application.routes.draw do
  
  resources :users, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]
  
  
  resources :subs, except: [:destroy] 
  resources :posts, except: [:index] do
    resources :comments, only: [:new, :create]
  end
  
  resources :comments, only: [:edit, :update, :destroy]
  
  root 'subs#index'
  
end
