class Watcher < ApplicationRecord
  belongs_to :user
  belongs_to :issue
  belongs_to :company

  validates_uniqueness_of :issue_id, scope: :user_id

  def inform_started_watching
    WatcherMailer.delay.watching_issue_now(user, issue, company.subdomain)
  end

  def inform_stopped_watching
    WatcherMailer.delay.stopped_watching_issue(user, issue, company.subdomain)
  end
end
