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
        format.html { redirect_to user_path }
        end
      else
        flash[:danger] = t('flash_messages.error', error_msg: @user.errors.full_messages.first)
        respond_to do |format|
        format.html { render 'edit' }
        end
      end
  end

  def destroy
    binding.pry
    if @user.destroy
      flash.now[:notice] = t('users.successful_deletion_message')
    else
      flash.now[:error] = t('users.unsuccessful_deletion_message')
    end

    respond_to do |format|
      format.html { redirect_to users_path }
    end
  end

  def filters
    if(params[:search].present?)
      if params[:search].eql? User::ROLES[0]
        @users = @users.where(role: User::ROLES[0])
      elsif params[:search].eql? User::ROLES[1]
        @users = @users.where(role: User::ROLES[1])
      elsif params[:search].eql? User::ROLES[2]
        @users = @users.where(role: User::ROLES[2])
      end
    end
    @pagy, @users = pagy(@users.order(created_at: :desc), items: Company::PAGE_SIZE)
    respond_to do |format|
      format.js
    end
  end

  private

  def edit_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end
