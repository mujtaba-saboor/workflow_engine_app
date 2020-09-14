class Project < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :project_category, presence: true, inclusion: { in: %w(TEAM INDIVIDUAL)}

  belongs_to :company

  has_many :project_teams, dependent: :destroy
  has_many :teams, through: :project_teams

  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users
end