class Project < ApplicationRecord
  has_many :project_teams
  has_many :teams, through: :project_teams

  has_many :project_users

  validates :name, presence: true, uniqueness: true
  validates :project_category, presence: true, inclusion: { in: %w(TEAM INDIVIDUAL)}
end