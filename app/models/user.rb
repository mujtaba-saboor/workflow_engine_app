class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  ROLES = %w[STAFF ADMIN OWNER].freeze

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable
  belongs_to :company
  accepts_nested_attributes_for :company

  has_many :project_users
  has_many :projects, through: :project_users
  has_many :team_users
  has_many :teams, through: :team_users
  has_many :comments, dependent: :destroy
  has_many :watchers, dependent: :destroy
  has_many :created_issues, class_name: 'Issue', foreign_key: 'creator_id', inverse_of: 'creator', dependent: :destroy
  has_many :assigned_issues, class_name: 'Issue', foreign_key: 'assignee_id', inverse_of: 'assignee', dependent: :nullify

  def all_projects
    company = Company.first
    all_individual_projects = projects.ids
    all_team_projects = company.projects.joins(:teams).where(teams: { id: self.teams.pluck(:id) }).pluck(:id)
    company.projects.where(id: all_individual_projects | all_team_projects)
  end

  def get_project_count
    if(self.role.eql? ROLES[0])
      all_projects.count
    else
      Project.all.count
    end
  end

  # Specifically made for STAFF user
  def get_team_project_count
    Project.where(project_category: Project::PROJECT_CATEGORIES[0]).where(id: self.teams.pluck(:id)).count
  end

  def get_team_count
    if(self.role.eql? ROLES[0])
      self.teams.count
    else
      Team.all.count
    end
  end

  def staff?
    role == ROLES[0]
  end

  def admin?
    role == ROLES[1]
  end

  def account_owner?
    role == ROLES[2]
  end
end
