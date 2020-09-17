class CompaniesController < ApplicationController
  # get '', to: 'companies#company', constraints: { subdomain: /.+/ }
  def company
    @company = current_company
    @projects = Project.all
    @issues = Issue.all
    flash.now[:notice] = t('companies.welcome_message', company_name: @company.name)
  end
end
