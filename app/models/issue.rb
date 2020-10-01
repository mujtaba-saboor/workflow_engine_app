# frozen_string_literal: true

class Issue < ApplicationRecord
  include AASM

  PAGE_SIZE = 5

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :watchers, dependent: :destroy

  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  belongs_to :assignee, class_name: 'User', foreign_key: 'assignee_id', optional: true

  belongs_to :project
  belongs_to :company

  has_many_attached :documents

  enum issue_type: %i[bug issue], _prefix: true
  enum priority: %i[low high], _prefix: true
  enum status: %i[open in_progress resolved closed], _prefix: true

  validates :title, :issue_type, :priority, :status, presence: true

  aasm column: :status, enum: true do
    state :open, initial: true
    state :in_progress, :resolved, :closed
    after_all_transitions :transition_callback

    event :start do
      transitions from: :open, to: :in_progress
    end

    event :resolve do
      transitions from: %i[open in_progress], to: :resolved
    end

    event :close do
      transitions from: %i[open in_progress resolved], to: :closed
    end

    event :reopen do
      transitions from: %i[resolved closed], to: :open
    end
  end

  AASM_EVENTS_HUMANIZED = Issue.aasm.events.map(&:name).map(&:to_s).map(&:humanize)

  def transition_callback
    inform_status_change
  end

  def user_watchers
    project
      .members
      .joins("LEFT OUTER JOIN watchers ON watchers.user_id = users.id and watchers.issue_id = #{id}")
      .select('users.id as user_id, users.name as user_name, users.email as user_email, watchers.id as watcher_id')
  end

  def inform_status_change
    watchers.includes(:user).each do |watcher|
      IssueMailer.with(
        user: watcher.user_id,
        issue: id,
        company: company_id,
        watching_as: :watcher
      ).status_changed.deliver_later
    end

    if assignee.present?
      IssueMailer.with(
        user: assignee_id,
        issue: id,
        company: company_id,
        watching_as: :assignee
      ).status_changed.deliver_later
    end

    IssueMailer.with(
      user: creator_id,
      issue: id,
      company: company_id,
      watching_as: :creator
    ).status_changed.deliver_later
  end
end
