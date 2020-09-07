class Project < ApplicationRecord
  has_many :project_teams
  has_many :teams, through: :project_teams

  has_many :project_users
end