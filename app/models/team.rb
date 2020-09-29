class Team < ApplicationRecord
  sequenceid :company, :teams
  validates :name, presence: true, uniqueness: true

  belongs_to :company

  has_many :project_teams
  has_many :projects, through: :project_teams

  has_many :team_users, dependent: :destroy
  has_many :users, through: :team_users

  def available_users
    company.users.where.not(id: users.pluck(:id))
  end
end
