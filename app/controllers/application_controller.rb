class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :filter_unwanted_urls
  before_action :authenticate_user!
  around_action :scope_current_company

  protected

  UNWANTED_BASE_PATHS = [
    # '/users/sign_in',
    '/users/sign_out'
  ].freeze

  UNWNATED_SUBDOMAIN_PATHS = [
    '/users/sign_up'
  ].freeze

  # Check if the given path is in the manually blocked lists in subdomains or without subdomains
  def path_blocked?(path, request_type = :base)
    if request_type == :base
      UNWANTED_BASE_PATHS.include? path
    elsif request_type == :subdomain
      UNWNATED_SUBDOMAIN_PATHS.include? path
    end
  end
  helper_method :path_blocked?

  # Check if the given path is manually blocked from the current request location
  def path_blocked_from_location?(path, request)
    request_type = request.subdomain.present? ? :subdomain : :base
    path_blocked?(path, request_type)
  end
  helper_method :path_blocked_from_location?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name email password role is_confirmed company_id])
  end

  def filter_unwanted_urls
    request_type = request.subdomain.present? ? :subdomain : :base
    not_found if path_blocked?(request.path, request_type)
  end

  def current_company
    Company.find_by_domain! request.subdomain if request.subdomain.present?
  end
  helper_method :current_company

  def scope_current_company
    company = current_company
    Company.current_id = company ? current_company.id : nil
    yield
  ensure
    Company.current_id = nil
  end

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end
end
