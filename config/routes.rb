Rails.application.routes.draw do
  get '', to: 'companies#company', constraints: { subdomain: /.+/ }
  root 'home#index'
  resources :companies do
    resources :users
  end
  get '/users/sign_in', to: 'home#sign_in', constraints: { subdomain: '' }
  post '/user/companies', to: 'home#user_companies', as: 'user_companies'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # get '/patients/:id', to: 'patients#show', as: 'patient'
end
