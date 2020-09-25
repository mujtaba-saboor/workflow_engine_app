class InvitesController < ApplicationController
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
      InviteMailer.with(invite: @invite, path: confirm_request_path(invite_token: @invite.token)).new_user_invite.deliver #send the invite data to our mailer to deliver the email
      flash[:success] = t('invites.send_successful')
      respond_to do |format|
        format.html { redirect_to new_invite_path }
      end
    else
      flash[:danger] = t('flash_messages.error', error_msg: @project.errors.full_messages.first)
    end
  end

  def confirm_request
    binding.pry
    @user = User.new
  end

  def create_staff_user
      #user will be created here
  end

  def invite_params
    params.require(:invite).permit(:company_id, :email)
  end
end
