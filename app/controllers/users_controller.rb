include Pagy::Backend
class UsersController < ApplicationController
  load_and_authorize_resource find_by: :sequence_num, through: :current_company
  add_breadcrumb I18n.t('shared.home'), :root_path, only: [:index, :show, :edit]
  add_breadcrumb I18n.t('shared.users'), :users_path, only: [:index, :show, :edit]

  def show
    add_breadcrumb @user.name, :user_path
    respond_to { |format| format.html }
  end

  def index
    @pagy, @users = pagy(@users,  items: Company::PAGE_SIZE)
    respond_to { |format| format.html }
  end

  def edit
    add_breadcrumb @user.name, :user_path
    add_breadcrumb t('shared.edit'), :edit_user_path
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

  def destroy
    if @user.destroy
      flash.now[:notice] = t('comments.successful_deletion_message')
      @comment = Comment.new
    else
      flash.now[:error] = t('comments.unsuccessful_deletion_message')
    end

    respond_to do |format|
      format.html { redirect_back fallback_location: root_url }
      format.js
    end
  end
  private

  def edit_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end
