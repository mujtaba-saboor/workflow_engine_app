class UsersController < ApplicationController
  load_and_authorize_resource find_by: :sequence_num, through: :current_company
  def show
    add_breadcrumb @user.name, :user_path
    respond_to { |format| format.html }
  end

  def index
    add_breadcrumb t('shared.users'), :users_path
    @pagy, @users = pagy(@users,  items: Company::PAGE_SIZE)
    respond_to { |format| format.html }
  end
end
