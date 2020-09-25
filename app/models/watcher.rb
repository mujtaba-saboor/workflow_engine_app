class Watcher < ApplicationRecord
  belongs_to :user
  belongs_to :issue
  belongs_to :company

  validates_uniqueness_of :issue_id, scope: :user_id

  def inform_started_watching
    WatcherMailer.with(user: user, issue: issue, subdomain: company.subdomain).watching_issue_now.deliver_later
  end

  def inform_stopped_watching
    WatcherMailer.with(user: user, issue: issue, subdomain: company.subdomain).stopped_watching_issue.deliver_later
  end
end
