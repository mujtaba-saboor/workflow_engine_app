class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  skip_around_action :scope_current_company
  def index
    flash.now[:notif] = "Welcome to Workflow Engine"
  end
end
