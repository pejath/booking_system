Rails.application.routes.draw do
  devise_for :users
  devise_for :clients
  devise_for :administrators
  resources :administrators, only: %i[new create destroy show edit update]
  resources :clients, only: %i[new create destroy show edit update]
  resources :bills, only: %i[show create]
  resources :apartments
  resources :requests
  resources :hotels
  resources :users
  root to: 'apartments#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
