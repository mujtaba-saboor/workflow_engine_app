Rails.application.routes.draw do
  
  root 'home#index'
  resources :companies do
    resources :users  
  end

  resources :projects do
    member do
      get 'project_users'
      get 'new_team'
      patch 'add_team_to_project'
      delete 'remove_team_from_project'
      get 'new_user'
      patch 'add_user_to_project'
      delete 'remove_user_from_project'
    end
  end
  resources :teams do
    member do
      get 'new_user'
      patch 'add_user_to_team'
      delete 'remove_user_from_team'
    end
  end

  devise_for :user

end
