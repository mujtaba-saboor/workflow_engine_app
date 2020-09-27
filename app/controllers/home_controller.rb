class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  # GET '', subdomain: ''
  def index
    # flash.now[:notice] = t('home.welcome_message')
    respond_to do |format|
      format.html
    end
  end

  # GET '/users/sign_in', subdomain: ''
  def sign_in
    respond_to do |format|
      format.html
    end
  end

  # get '/user/companies', subdomain: ''
  def user_companies
    email = params[:email]
    @companies = User.unscoped.joins(:company).where('users.email = ?', email).select('companies.*')
    flash.now[:error] = t('home.no_associated_companies_message', email: email) if @companies.empty?
    respond_to do |format|
      format.js
    end
  end
end
