class Comment < ApplicationRecord
  default_scope { order(created_at: :desc) }
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  belongs_to :company

  validates :body, presence: true
end
