# frozen_string_literal: true

class IssueMailer < ApplicationMailer
  def status_change(user, issue, subdomain)
    send_mail(user, issue, subdomain)
  end

  def send_mail(user, issue, subdomain)
    @user = user
    @issue = issue
    @subdomain = subdomain

    mail to: @user.email
  end
end
