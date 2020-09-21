Rails.application.routes.draw do
  root 'home#index'
  resources :companies do
    resources :users
  end
  devise_for :users

  resources :projects do
    resources :issues do
      member do
        patch :update_status
      end
    end
  end

  resources :issues, only: [] do
    resources :comments, only: %i[create edit update destroy]
  end
  # resources :comments, only: %i[destroy edit update]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
