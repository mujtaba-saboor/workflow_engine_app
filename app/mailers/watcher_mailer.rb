# frozen_string_literal: true

class WatcherMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.watcher_mailer.watching_issue_now.subject
  #
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
