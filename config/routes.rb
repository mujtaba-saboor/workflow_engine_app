Rails.application.routes.draw do
  resources :projects do
    member do
      get 'project_users'
      get 'new_team_for_project'
      patch 'add_team_to_project'
      delete 'remove_team_from_project'
      get 'new_user_for_project'
      patch 'add_user_to_project'
      delete 'remove_user_from_project'
    end

    resources :issues do
      member do
        patch :update_status
      end
    end
  end

  resources :teams do
    member do
      get 'new_user_for_team'
      patch 'add_user_to_team'
      delete 'remove_user_from_team'
    end
  end

  resources :issues, only: [] do
    resources :comments, only: %i[create edit update destroy]
  end

  devise_for :user

  root 'home#index'
end
