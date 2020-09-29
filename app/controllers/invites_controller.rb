class InvitesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:confirm_request, :create_staff_user]
  def new
    @invite = Invite.new
    @token = params[:invite_token] #<-- pulls the value from the url query string
  end

  def create
    @invite = Invite.new(invite_params) # Make a new Invite
    @invite.sender_id = current_user.id # set the sender to the current user
    @invite.recipient = User.new
    @invite.recipient.email = @invite.email
    @invite.recipient.role = User::ROLES[0]
    @invite.recipient.company = current_company
    if @invite.save
      InviteMailer.with(invite: @invite, path: confirm_request_path(email: @invite.recipient.email, company: current_company)).new_user_invite.deliver #send the invite data to our mailer to deliver the email
      flash[:success] = t('invites.send_successful')
      respond_to do |format|
        format.html { redirect_to new_invite_path }
      end
    else
      flash[:danger] = t('flash_messages.error', error_msg: @invite.errors.full_messages.first)
    end
  end

  def confirm_request
    @email = params[:email]
    @company = params[:company]
    @user = User.new
  end

  def create_staff_user
    @user = User.new
    @user.company = Company.all.find(confirm_params[:company_id])
    @user.name = confirm_params[:name]
    @user.role = confirm_params[:role]
    @user.email = confirm_params[:email]
    @user.password = confirm_params[:password]
    @user.password_confirmation = confirm_params[:password_confirmation]
    if @user.save
      flash[:success] = t('users.user_created_successfully')
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
