class Project < ApplicationRecord
  
  def self.project_categories
    %w[TEAM INDIVIDUAL]
  end

  validates :name, presence: true, uniqueness: true
  validates :project_category, presence: true, inclusion: { in: project_categories }

  belongs_to :company

  has_many :project_teams, dependent: :destroy
  has_many :teams, through: :project_teams

  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users
end