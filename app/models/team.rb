class Team < ApplicationRecord
  default_scope { where(company_id: Company.current_id) }
  validates :name, presence: true, uniqueness: true

  belongs_to :company

  has_many :project_teams
  has_many :projects, through: :project_teams

  has_many :team_users, dependent: :destroy
  has_many :users, through: :team_users

  def available_users
    User.where.not(id: self.users.pluck(:id))
  end
end
