class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    flash.now[:notice] = "Welcome to Workflow Engine"
    respond_to :html
  end

  # get '/users/sign_in', to: 'home#sign_in', constraints: { subdomain: '' }
  def sign_in
    respond_to :html
  end

  # get '/user/companies', to: 'home#user_companies', as: user_companies
  def user_companies
    email = params[:email]
    @companies = Company.joins("INNER JOIN users ON users.email = '#{User.sanitize_sql(email)}' AND users.company_id = companies.id")
    respond_to :js
  end
end
