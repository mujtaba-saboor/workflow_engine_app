class Project < ApplicationRecord
  default_scope { where(company_id: Company.current_id) }
  belongs_to :company

  has_many :project_teams
  has_many :teams, through: :project_teams

  has_many :project_users
  has_many :users, through: :project_users

  has_many :issues
end
