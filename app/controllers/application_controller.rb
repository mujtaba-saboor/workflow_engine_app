class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  around_action :scope_current_company
  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to main_app.root_url, notice: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role, company_attributes: [:name, :subdomain]])
  end

  def current_company
    Company.find_by_subdomain! request.subdomain if request.subdomain.present?
  end
  helper_method :current_company

  def scope_current_company
    @current_company = current_company
    Company.current_id = @current_company.try(:id)
    yield
  ensure
    Company.current_id = nil
  end
end
