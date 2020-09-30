class InvitesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:confirm_request, :create_staff_user]
  load_and_authorize_resource only: [:new, :create]

  # GET /invites/new
  def new
    add_breadcrumb t('shared.home'), :root_path
    add_breadcrumb t('shared.users'), :users_path
    add_breadcrumb t('shared.create_model', model: t('shared.user'))
    @token = params[:invite_token] #<-- pulls the value from the url query string
  end

  # POST /invites
  def create
    @invite.recipient = User.new(email: @invite.email, role: User::ROLES[0], company: current_company)
    @invite.sender_id = current_user.id
    if @invite.save
      InviteMailer.new_user_invite(invite: @invite, path: confirm_request_path(email: @invite.recipient.email, company: current_company, target: '_blank')).deliver #send the invite data to our mailer to deliver the email
      flash[:success] = t('invites.send_successful')
      respond_to do |format|
        format.html { redirect_to new_invite_path }
      end
    else
      flash[:danger] = t('flash_messages.error', error_msg: @invite.errors.full_messages.first)
    end
  end

  # GET /invites/confirm_request
  def confirm_request
    @email = params[:email]
    @company = params[:company]
    @user = User.new
  end

# GET /invites/create_staff_user
  def create_staff_user
    @user = User.new(company_id: confirm_params[:company_id], name: confirm_params[:name], role: confirm_params[:role], email: confirm_params[:email], password: confirm_params[:password], password_confirmation: confirm_params[:password_confirmation])
    if @user.save
      flash[:success] = t('flash_messages.create', name: t('shared.user'))
      respond_to do |format|
        format.html { redirect_to '/users/sign_in' }
      end
    else
      flash[:danger] = t('flash_messages.error', error_msg: @user.errors.full_messages.first)
    end
  end

  def invite_params
    params.require(:invite).permit(:company, :email)
  end

  def confirm_params
    params.require(:user).permit(:name, :company_id, :role, :email, :password, :password_confirmation)
  end
end
