class CompaniesController < ApplicationController
  # GET '', subdomain: /.+/
  def index
    @company = current_company
    @projects = Project.all
    @issues = Issue.all
    @users = User.all
    flash.now[:notice] = t('companies.welcome_message', company_name: @company.name)
    respond_to do |format|
      format.html
    end
  end
end
