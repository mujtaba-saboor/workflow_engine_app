class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  # GET '', subdomain: ''
  def index
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

    respond_to do |format|
      if @companies.size == 1
        format.js { redirect_to new_user_session_url(subdomain: @companies.first.subdomain) }
      else
        flash.now[:error] = t('home.no_associated_companies_message', email: email) if @companies.empty?
        format.js
      end
    end
  end
end
