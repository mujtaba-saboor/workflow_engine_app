Rails.application.routes.draw do
  
  root 'home#index'
  resources :companies do
    resources :users  
  end

  resources :projects do
    member do
      get 'new_team'
      patch 'create_team'
      delete 'remove_team'
      get 'new_user'
      patch 'create_user'
      delete 'remove_user'

    end
  end
  resources :teams do
    member do
      get 'new_member'
      patch 'create_member'
      delete 'remove_member'
      get 'remove'
    end
  end

  devise_for :user

  get '/projects/:id/users', to: 'projects#project_users', as: :project_users

end
