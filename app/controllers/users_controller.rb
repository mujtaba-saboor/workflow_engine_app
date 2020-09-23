include Pagy::Backend
class UsersController < ApplicationController
  load_and_authorize_resource
  def show
    @company = current_company
    @users = @company.users.find_by_sequence_num!(params[:id])
    flash.now[:notif] = "Welcome to Specific User Page of (#{@company.name})"
    respond_to do |format|
        format.html
    end
  end

  def index
    @pagy, @users = pagy(User.where(params[:company_id]),  items: 5)
  end
end
