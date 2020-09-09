class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  belongs_to :company

  validates :body, presence: true
end
