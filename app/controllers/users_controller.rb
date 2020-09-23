include Pagy::Backend
class UsersController < ApplicationController
  before_action :authenticate_user!
  def index
    @pagy, @users = pagy(User.where(params[:company_id]),  items: Company::PAGE_SIZE)
  end
end
