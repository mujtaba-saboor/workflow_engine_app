class PagesController < ApplicationController
  def home
    flash.now[:notif] = 'Welcome to Workflow Engine app...'
  end
end
