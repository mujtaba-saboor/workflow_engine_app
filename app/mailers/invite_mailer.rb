class InviteMailer < ApplicationMailer
  def new_user_invite(params)
    @invite = params[:invite]
    @path = "http://lvh.me:3000#{params[:path]}"
    mail(to: @invite.email, subject: 'Welcome')
  end
end
