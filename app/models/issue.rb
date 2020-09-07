# frozen_string_literal: true

class Issue < ApplicationRecord
  has_many :comments, as: :commentable

  enum type: %i[bug issue]
  enum priority: %i[low high]
  enum status: %i[open in_progress resolved closed]

  validates :title, :type, :priority, :status, presence: true
end
