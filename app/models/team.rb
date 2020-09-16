class Team < ApplicationRecord
  default_scope { where(company_id: Company.current_id) }
  belongs_to :company

  has_many :project_teams
  has_many :projects, through: :project_teams

  has_many :team_users
  has_many :users, through: :team_users
end
