class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  around_action :scope_current_company

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :role, :is_confirmed, :company_id])
  end

  def current_company
    Company.find_by_domain! request.subdomain
  end
  helper_method :current_company

  def scope_current_company
    Company.current_id = current_company.id
    yield
  ensure
    Company.current_id = nil
  end
end
