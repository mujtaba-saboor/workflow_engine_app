# frozen_string_literal: true

class WatcherMailer < ApplicationMailer
  before_action :set_resources
  default to: -> { @user.email }

  def watching_issue_now
    mail
  end

  def stopped_watching_issue
    mail
  end

  private

  def set_resources
    @user = params[:user]
    @issue = params[:issue]
    @subdomain = params[:subdomain]
  end
end
