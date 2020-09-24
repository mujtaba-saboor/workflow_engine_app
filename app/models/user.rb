class User < ApplicationRecord
  sequenceid :company ,:users
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::Models::Validatable
  devise :database_authenticatable, :registerable, :invitable, :confirmable, :lockable,
         :recoverable, :rememberable # , :validatable

  # https://github.com/heartcombo/devise/blob/master/lib/devise/models/validatable.rb
  validates_uniqueness_of :email, scope: :company_id
  validates_format_of     :email, with: email_regexp, allow_blank: true, if: :email_changed?
  validates_presence_of     :password, if: :password_required?
  validates_confirmation_of :password, if: :password_required?
  validates_length_of       :password, within: password_length, allow_blank: true

  ROLES = %w[STAFF ADMIN OWNER].freeze

  belongs_to :company, optional: true
  accepts_nested_attributes_for :company

  has_many :project_users
  has_many :projects, through: :project_users
  has_many :team_users
  has_many :teams, through: :team_users
  has_many :comments, dependent: :destroy
  has_many :watchers, dependent: :destroy
  has_many :created_issues, class_name: 'Issue', foreign_key: 'creator_id', inverse_of: 'creator', dependent: :destroy
  has_many :assigned_issues, class_name: 'Issue', foreign_key: 'assignee_id', inverse_of: 'assignee', dependent: :nullify

  def self.find_for_authentication(warden_conditions)
    where(email: warden_conditions[:email], company_id: Company.current_id).first
  end

  validates :role, inclusion: { in: %w(OWNER STAFF ADMIN),
  message: "%{value} is not a valid role" }

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
    role == ROLES[0]
  end

  def admin?
    role == ROLES[1]
  end

  def account_owner?
    role == ROLES[2]
  end
end
