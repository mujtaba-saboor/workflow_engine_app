class InviteMailer < ApplicationMailer
  skip_before_action :load_company

  def new_user_invite(params)
    @invite = params[:invite]
    @path = "http://lvh.me:3000#{params[:path]}"
    mail(to: @invite.email, subject: 'Welcome')
  end
end
