# frozen_string_literal: true

class WatcherMailer < ApplicationMailer
  before_action :set_resources
  around_action :validate_action

  default to: -> { @user.email }

  def watching_issue_now
    mail subject: t('watcher_mailer.watching_issue_now.subject', issue_id: @issue.id)
  end

  def stopped_watching_issue
    mail subject: t('watcher_mailer.stopped_watching_issue.subject', issue_id: @issue.id)
  end

  private

  def set_resources
    @user = load_resource { @company.users.find_by(id: params[:user], company_id: params[:company]) }
    @issue = load_resource { @company.issues.find_by(id: params[:issue], company_id: params[:company]) }
  end
end
