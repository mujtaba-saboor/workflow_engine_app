# frozen_string_literal: true
class Issue < ApplicationRecord
  include AASM

  has_many :comments, as: :commentable

  enum issue_type: %i[bug issue], _prefix: true
  enum priority: %i[low high], _prefix: true
  enum status: %i[open in_progress resolved closed], _scopes: false, _prefix: true

  validates :title, :type, :priority, :status, presence: true

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
