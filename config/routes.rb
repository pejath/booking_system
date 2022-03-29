Rails.application.routes.draw do
  resources :clients, only: %i[new create destroy show edit update]
  resources :bills, only: %i[show create]
  resources :administrators, only: %i[new create destroy show edit update]
  resources :hotels
  resources :apartments

  resources :requests
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
