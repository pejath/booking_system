Rails.application.routes.draw do
  resources :administrators, only: %i[new create destroy show edit update]
  resources :clients, only: %i[new create destroy show edit update]
  resources :bills, only: %i[show create]
  resources :hotels
  resources :apartments

  resources :requests
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
