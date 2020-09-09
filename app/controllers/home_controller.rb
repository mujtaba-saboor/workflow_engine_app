class HomeController < ApplicationController
  def index
    flash.now[:notif] = 'Welcome to Workflow Engine'
  end
end
