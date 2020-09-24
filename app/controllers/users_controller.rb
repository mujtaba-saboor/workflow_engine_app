include Pagy::Backend
class UsersController < ApplicationController
  load_and_authorize_resource find_by: :sequence_num, through: :current_company
  def show
    add_breadcrumb t('users.username', user_name: current_user.name), :user_path
    respond_to { |format| format.html }
  end

  def index
    add_breadcrumb t('shared.users'), :users_path
    @pagy, @users = pagy(@users,  items: Company::PAGE_SIZE)
    respond_to { |format| format.html }
  end
end
