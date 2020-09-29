include Pagy::Backend
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

  def edit
    respond_to { |format| format.html }
  end

  def update
      if @user.update(edit_params)
        flash[:success] = t('flash_messages.update', name: t('shared.user'))
        respond_to do |format|
        format.html { redirect_to user_path(@user) }
        end
      else
        flash[:danger] = t('flash_messages.error', error_msg: @user.errors.full_messages.first)
        respond_to do |format|
        format.html { render 'edit' }
        end
      end
  end

  private

  def edit_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end
