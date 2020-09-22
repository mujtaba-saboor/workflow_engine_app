include Pagy::Backend
class UsersController < ApplicationController
  def index
    @pagy, @users = pagy(User.where(params[:company_id]),  items: 5)
    add_breadcrumb "Show_Users", :company_users_path  
  end
end
