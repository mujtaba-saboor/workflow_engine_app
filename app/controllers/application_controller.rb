class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :filter_unwanted_urls
  around_action :scope_current_company
  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to main_app.root_url, notice: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  UNWANTED_BASE_PATHS = [
  ].freeze

  UNWANTED_SUBDOMAIN_PATHS = [
    '/users/sign_up'
  ].freeze

  def route_not_found
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end

  def handle_record_not_found
    render 'layouts/record_not_found.html.erb', layout: false
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role, company_attributes: [:name, :subdomain]])
  end

  # Check if the given path is in the manually blocked lists, in subdomains or without subdomains
  def path_blocked?(path, request_type = :base)
    if request_type == :base
      UNWANTED_BASE_PATHS.include? path
    elsif request_type == :subdomain
      UNWANTED_SUBDOMAIN_PATHS.include? path
    end
  end
  helper_method :path_blocked?

  # Check if the given path is manually blocked from the current request location
  def path_blocked_from_location?(path, request)
    request_type = request.subdomain.present? ? :subdomain : :base
    path_blocked?(path, request_type)
  end
  helper_method :path_blocked_from_location?

  def filter_unwanted_urls
    request_type = request.subdomain.present? ? :subdomain : :base
    not_found if path_blocked?(request.path, request_type)
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

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end
end
