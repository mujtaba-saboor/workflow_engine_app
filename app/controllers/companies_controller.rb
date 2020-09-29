class CompaniesController < ApplicationController
  # GET '', subdomain: /.+/
  def index
    add_breadcrumb t('shared.home'), :root_path
    flash.now[:notice] = t('companies.welcome_message', company_name: @current_company.name)
    respond_to do |format|
      format.html
    end
  end
end
