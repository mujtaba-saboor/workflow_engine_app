class Watcher < ApplicationRecord
  belongs_to :user
  belongs_to :issue
  belongs_to :company

  validates_uniqueness_of :issue_id, scope: :user_id

  def inform_started_watching
    WatcherMailer.with(user: user_id, issue: issue_id, company: company_id).watching_issue_now.deliver_later
  end

  def inform_stopped_watching
    WatcherMailer.with(user: user_id, issue: issue_id, company: company_id).stopped_watching_issue.deliver_later
  end
end
