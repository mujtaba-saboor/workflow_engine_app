# frozen_string_literal: true

class WatcherMailer < ApplicationMailer
  before_action :set_resources
  default to: -> { @user.email }

  def watching_issue_now
    mail subject: t('watcher_mailer.watching_issue_now.subject', issue_id: @issue.id)
  end

  def stopped_watching_issue
    mail subject: t('watcher_mailer.stopped_watching_issue.subject', issue_id: @issue.id)
  end

  private

  def set_resources
    @user = params[:user]
    @issue = params[:issue]
    @subdomain = params[:subdomain]
  end
end
