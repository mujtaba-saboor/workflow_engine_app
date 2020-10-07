class UsersController < ApplicationController
  load_and_authorize_resource find_by: :sequence_num, through: :current_company
  add_breadcrumb I18n.t('shared.home'), :root_path, only: [:index, :show, :edit, :make_owner_page]
  add_breadcrumb I18n.t('shared.users'), :users_path, only: [:index, :show, :edit, :make_owner_page]

  def show
    add_breadcrumb @user.name, :user_path
    respond_to { |format| format.html }
  end

  def index
    @pagy, @users = pagy(@users)
    respond_to { |format| format.html }
  end

  def edit
    add_breadcrumb @user.name, :user_path
    add_breadcrumb t('shared.edit').capitalize(), :edit_user_path
    respond_to { |format| format.html }
  end

  def update
    if @user.update(edit_params)
      flash[:notice] = t('flash_messages.update', name: t('shared.user'))
      respond_to do |format|
        format.html { redirect_to user_path(@user) }
      end
    else
      flash[:error] = t('flash_messages.error', error_msg: @user.errors.full_messages.first)
      respond_to do |format|
        format.html { redirect_to user_path(@user) }
      end
    end
  end

  def destroy
    if @user.destroy
      flash[:notice] = t('users.successful_deletion_message')
    else
      flash[:error] = t('users.unsuccessful_deletion_message')
    end

    respond_to do |format|
      format.html { redirect_to users_path }
    end
  end

  def filters
    search_options = {
      id: @users.pluck(:id),
      page: params[:page]
    }
    search_options[:role] = params[:search] if User::ROLES.include? params[:search]

    @pagy, @users = User.filter_search(nil, search_options)

    respond_to do |format|
      format.js
    end
  end

  def make_owner_page
    add_breadcrumb t('users.make_owner'), :make_owner_page_users_path
    admins = @users.where(role: User::ROLES[1])
    staff = @users.where(role: User::ROLES[0])
    @users = staff + admins
    respond_to { |format| format.html }
  end

  def make_owner
    if current_company.users.find_by(email: make_owner_params[:email]).update(role: User::ROLES[2])
      if current_user.update(role: User::ROLES[1])
        flash[:notice] = t('users.successful_owner_change_message')
        respond_to do |format|
          format.html { redirect_to users_path }
        end
      else
        flash[:error] = t('flash_messages.error', error_msg: @user.errors.full_messages.first)
        respond_to do |format|
          format.html { redirect_to users_path }
        end
      end
    else
      flash[:error] = t('flash_messages.error', error_msg: @user.errors.full_messages.first)
      respond_to do |format|
        format.html { redirect_to users_path }
      end
    end
  end

  private

  def edit_params
    params.require(:user).permit(:name, :role)
  end

  def make_owner_params
    params.require(:user).permit(:email)
  end
end
