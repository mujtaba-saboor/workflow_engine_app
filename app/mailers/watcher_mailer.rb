# frozen_string_literal: true

class WatcherMailer < ApplicationMailer
  def watching_issue_now(user, issue, subdomain)
    send_mail(user, issue, subdomain)
  end

  def stopped_watching_issue(user, issue, subdomain)
    send_mail(user, issue, subdomain)
  end

  private

  def send_mail(user, issue, subdomain)
    @user = user
    @issue = issue
    @subdomain = subdomain

    mail to: @user.email
  end
end
