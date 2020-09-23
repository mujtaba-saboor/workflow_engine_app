class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :invitable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable

  ROLES = %w[STAFF ADMIN OWNER].freeze

  belongs_to :company
  accepts_nested_attributes_for :company

  has_many :project_users
  has_many :projects, through: :project_users
  has_many :team_users
  has_many :teams, through: :team_users
  has_many :comments
  has_many :watchers

  def all_projects
    company = Company.first
    all_individual_projects = projects.ids
    all_team_projects = company.projects.joins(:teams).where(teams: { id: teams.pluck(:id) }).pluck(:id)
    company.projects.where(id: all_individual_projects | all_team_projects)
  end

  def get_project_count
    if staff?
      all_projects.count
    else
      Project.all.count
    end
  end

  # Specifically made for STAFF user
  def get_team_project_count
    Project.where(project_category: Project::PROJECT_CATEGORIES[0]).where(id: teams.pluck(:id)).count
  end

  def get_team_count
    if staff?
      teams.count
    else
      Team.all.count
    end
  end

  def staff?
    role.eql? ROLES[0]
  end

  def admin?
    role.eql? ROLES[1]
  end

  def owner?
    role.eql? ROLES[2]
  end
end
