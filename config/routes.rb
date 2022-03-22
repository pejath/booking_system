Rails.application.routes.draw do
  resources :clients, only: %i[new create destroy show edit update]
  resources :administrators, only: %i[new create destroy show edit update]
  resources :hotels do
    resources :apartments
  end
  resources :requests
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
