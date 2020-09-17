class CompaniesController < ApplicationController
  # get '', to: 'companies#company', constraints: { subdomain: /.+/ }
  def company
    @company = current_company
    @projects = Project.all
    @issues = Issue.all
    @users = User.all
    flash.now[:notif] = "Welcome to Workflow Engine (#{@company.name})"
  end

  def index
  end
end
