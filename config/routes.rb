Rails.application.routes.draw do
  get 'comments/create'
  root 'home#index'
  resources :companies do
    resources :users
  end
  devise_for :users

  resources :projects do
    resources :issues
  end

  resources :issues, only: [] do
    resources :comments, only: [:create, :update, :delete]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
