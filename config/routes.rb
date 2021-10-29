Rails.application.routes.draw do
  resources :blogs do
    resources :comments
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create, :show]
end
