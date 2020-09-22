include Pagy::Backend
class UsersController < ApplicationController
  def index
    @pagy, @users = pagy(User.where(params[:company_id]),  items: 5)
  end
end
