class Company < ApplicationRecord
  has_many :users
  has_many :projects
  has_many :project_users
  has_many :teams
  has_many :team_users
  has_many :project_teams

end
