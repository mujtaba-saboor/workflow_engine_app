class UsersController < ApplicationController
  skip_before_action :authenticate_user!
  def show
    @company = current_company
    @users = @company.users.find_by_sequence_num!(params[:id])
    flash.now[:notif] = "Welcome to Specific User Page of (#{@company.name})"
  end
end
