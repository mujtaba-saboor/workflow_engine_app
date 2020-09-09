Rails.application.routes.draw do
  root 'home#index'
  resources :companies do
    resources :users  
  end
  resources :projects , :teams
  devise_for :user

  get '/projects/:id/users', to: 'projects#project_users', as: :project_users
  get '/projects/:id/add_user', to: 'projects#add_user', as: :project_add_user
  get '/projects/:id/add_team', to: 'projects#add_team', as: :project_add_team

end
