include Pagy::Backend
class UsersController < ApplicationController
  load_and_authorize_resource
  def index
    add_breadcrumb t('shared.users'), :company_users_path
    @pagy, @users = pagy(User.where(params[:company_id]),  items: 5)
  end
end
