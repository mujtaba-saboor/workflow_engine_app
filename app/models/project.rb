class Project < ApplicationRecord
  belongs_to :company

  has_many :project_teams
  has_many :teams, through: :project_teams

  has_many :project_users
  has_many :users, through: :project_users

  has_many :issues
end
