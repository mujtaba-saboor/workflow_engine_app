class Watcher < ApplicationRecord
  belongs_to :user
  belongs_to :issue
  belongs_to :company

  validates_uniqueness_of :issue_id, scope: :user_id
end
