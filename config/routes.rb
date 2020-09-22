Rails.application.routes.draw do
  # Routes accessible with subdomain
  constraints(subdomain: /.+/) do
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
    end
    resources :teams do
      member do
        get 'new_user_for_team'
        patch 'add_user_to_team'
        delete 'remove_user_from_team'
      end
    end
    get '', to: 'companies#index'
    devise_for :users
  end

  # Routes accessible without subdomain
  constraints(subdomain: '') do
    get '/users/sign_in', to: 'home#sign_in'
    post '/user/companies', to: 'home#user_companies', as: 'user_companies'
    root 'home#index'
  end
  get '/users/:id', to: 'users#show', constraints: { subdomain: /.+/ }
end
