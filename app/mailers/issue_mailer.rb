# frozen_string_literal: true

class IssueMailer < ApplicationMailer
  before_action :set_resources
  default to: -> { @user.email }

  def status_changed
    mail subject: t("issue_mailer.status_changed.subject_for.#{@watching_as}", issue_id: @issue.id)
  end

  private

  def set_resources
    @user = params[:user]
    @issue = params[:issue]
    @subdomain = params[:subdomain]
    @watching_as = params[:watching_as]
  end
end
