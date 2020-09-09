class Watcher < ApplicationRecord
  belongs_to :user
  belongs_to :issue
  belongs_to :company
end
