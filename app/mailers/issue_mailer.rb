# frozen_string_literal: true

class IssueMailer < ApplicationMailer
  before_action :set_resources
  around_action :validate_action
  default to: -> { @user.email }

  def status_changed
    mail subject: t("issue_mailer.status_changed.subject_for.#{@watching_as}", issue_id: @issue.id)
  end

  private

  def set_resources
    @user = load_resource { @company.users.find_by(id: params[:user], company_id: params[:company]) }
    @issue = load_resource { @company.issues.find_by(id: params[:issue], company_id: params[:company]) }
    @watching_as = params[:watching_as]
  end
end
