class InviteMailer < ApplicationMailer
  def new_user_invite
    @invite = params[:invite]
    remaining_path = 'lvh.me:3000'
    @path  = remaining_path + params[:path]
    mail(to: @invite.email, subject: 'Welcome')
  end
end
