include Pagy::Backend
class UsersController < ApplicationController
  load_and_authorize_resource find_by: :sequence_num, through: :current_company
  def show
    respond_to { |format| format.html }
  end

  def index
    add_breadcrumb t('shared.users'), :company_users_path
    @pagy, @users = pagy(@users,  items: Company::PAGE_SIZE)
    respond_to { |format| format.html }
  end
end
