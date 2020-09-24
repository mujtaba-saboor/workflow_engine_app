include Pagy::Backend
class UsersController < ApplicationController
  load_and_authorize_resource find_by: :sequence_num, through: :current_company
  def show
    respond_to { |format| format.html }
  end

  def index
    @pagy, @users = pagy(@users,  items: Company::PAGE_SIZE)
    respond_to { |format| format.html }
  end
end
