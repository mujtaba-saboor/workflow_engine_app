Rails.application.routes.draw do
  get '', to: 'companies#company', constraints: { subdomain: /.+/ }

  root 'home#index'
  resources :companies do
    resources :users
  end
  devise_for :users
  get '/users/:id', to: 'users#show', constraints: { subdomain: /.+/ }
end
