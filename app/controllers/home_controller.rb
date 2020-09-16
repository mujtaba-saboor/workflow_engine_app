class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    flash.now[:notif] = "Welcome to Workflow Engine"
  end
end
