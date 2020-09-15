Rails.application.routes.draw do
  get '', to: 'companies#company', constraints: { subdomain: /.+/ }
  root 'home#index'
  resources :companies do
    resources :users
  end
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
