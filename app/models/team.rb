class Team < ApplicationRecord
  has_many :project_teams
  has_many :projects, through: :project_teams

  has_many :team_users

  validates :name, presence: true, uniqueness: true
end
