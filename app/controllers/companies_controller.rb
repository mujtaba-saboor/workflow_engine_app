class CompaniesController < ApplicationController
  # GET '', subdomain: /.+/
  def index
<<<<<<< HEAD
    @company = current_company
    @projects = Project.all
    @issues = Issue.all
    @users = User.all
    flash.now[:notice] = t('companies.welcome_message', company_name: @company.name)
=======
    flash.now[:notice] = t('companies.welcome_message', company_name: @current_company.name)
>>>>>>> 03edf608761c89094ceccb25e1483faaea3bc9bc
    respond_to do |format|
      format.html
    end
  end
end
