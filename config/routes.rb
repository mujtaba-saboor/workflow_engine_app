Rails.application.routes.draw do
  #devise_for :users, path: 'auth', path_names: { sign_in: 'login'}
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
