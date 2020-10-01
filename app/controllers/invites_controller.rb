class InvitesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:confirm_request, :create_staff_user]
  load_and_authorize_resource only: [:new, :create]
  before_action :load_invite_or_redirect, only: [:confirm_request, :create_staff_user]

  # GET /invites/new
  def new
    add_breadcrumb t('shared.home'), :root_path
    add_breadcrumb t('shared.users'), :users_path
    add_breadcrumb t('shared.create_model', model: t('shared.user'))
  end

  # POST /invites
  def create
    if @invite.save
      InviteMailer.new_user_invite(invite: @invite, path: confirm_request_path(token: @invite.token, role: @invite.role)).deliver
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
    @user = User.new

    respond_to do |format|
      format.html
    end
  end

  # GET /invites/create_staff_user
  def create_staff_user
    @user = User.new(company_id: @invite.company_id, name: confirm_params[:name], role: @invite.role, email: @invite.email, password: confirm_params[:password], password_confirmation: confirm_params[:password_confirmation])
    if @user.save
      flash[:success] = t('flash_messages.create', name: t('shared.user'))
      respond_to do |format|
        format.html { redirect_to '/users/sign_in' }
      end
    else
      flash[:danger] = t('flash_messages.error', error_msg: @user.errors.full_messages.first)
    end
  end

  def load_invite_or_redirect
    @invite = Invite.unscoped.find_by(token: params[:token] || confirm_params[:token])
    handle_record_not_found and return if @invite.blank?
  end

  def invite_params
    params.require(:invite).permit(:email, :sender_id, :role)
  end

  def confirm_params
    params.require(:user).permit(:name, :token, :password, :password_confirmation)
  end
end
