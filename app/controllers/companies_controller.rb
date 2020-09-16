class CompaniesController < ApplicationController
  def company
    @company = current_company
    @projects = Project.all
    @issues = Issue.all
    flash.now[:notif] = "Welcome to Workflow Engine (#{@company.name})"
  end

  def index
  end
end
