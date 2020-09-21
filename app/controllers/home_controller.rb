class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    flash.now[:notice] = t('home.welcome_message')
    respond_to do |format|
      format.html
    end
  end

  # get '/users/sign_in', to: 'home#sign_in', constraints: { subdomain: '' }
  def sign_in
    respond_to do |format|
      format.html
    end
  end

  # get '/user/companies', to: 'home#user_companies', as: user_companies
  def user_companies
    email = params[:email]
    @companies = Company.joins(:users).where('users.email = ?', email)
    flash.now[:error] = t('home.no_associated_companies_message', email: email) if @companies.empty?
    respond_to do |format|
      format.js
    end
  end
end
