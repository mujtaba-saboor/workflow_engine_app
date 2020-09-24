class Watcher < ApplicationRecord
  belongs_to :user
  belongs_to :issue
  belongs_to :company

  validates_uniqueness_of :issue_id, scope: :user_id

  def self.watching_issue?(user, issue)
    find_by(issue_id: issue.id, user_id: user.id)
  end
end
