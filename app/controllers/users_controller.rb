include Pagy::Backend
class UsersController < ApplicationController
  load_and_authorize_resource find_by: :sequence_num
  def show
    respond_to do |format|
        format.html
    end
  end

  def index
    @pagy, @users = pagy(User.where(params[:company_id]),  items: 5)
  end
end
