class HomeController < ApplicationController
  def index
    flash.now[:notif] = t('home.welcome')
  end
end
