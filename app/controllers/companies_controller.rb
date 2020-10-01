class CompaniesController < ApplicationController
  # GET '', subdomain: /.+/
  def index
    add_breadcrumb t('shared.home'), :root_path
    respond_to do |format|
      format.html
    end
  end
end
