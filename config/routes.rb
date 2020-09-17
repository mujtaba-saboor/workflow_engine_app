Rails.application.routes.draw do
  get '', to: 'companies#company', constraints: { subdomain: /.+/ }
  root 'home#index'
  resources :companies do
    resources :users
  end
  get '/users/sign_in', to: 'home#sign_in', constraints: { subdomain: '' }
  post '/user/companies', to: 'home#user_companies', as: 'user_companies'
  devise_for :users
  get '/users/:id', to: 'users#show', constraints: { subdomain: /.+/ }
end
