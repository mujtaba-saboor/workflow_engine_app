# frozen_string_literal: true
class Issue < ApplicationRecord
  include AASM

  has_many :comments, as: :commentable

  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  belongs_to :assignee, class_name: 'User', foreign_key: 'assignee_id'

  belongs_to :project
  belongs_to :company

  enum issue_type: %i[bug issue], _prefix: true
  enum priority: %i[low high], _prefix: true
  enum status: %i[open in_progress resolved closed], _scopes: false, _prefix: true

  validates :title, :issue_type, :priority, :status, presence: true

  aasm column: :status, enum: true do
    state :open, initial: true
    state :in_progress, :resolved, :closed
    after_all_transitions :transition_callback

    event :reopen do
      transitions from: :closed, to: :open
    end
  end

  def transition_callback
    puts "Current event: #{aasm.current_event}"
    puts "Transition Callback: from #{aasm.from_state} to #{aasm.to_state}"
  end
end
