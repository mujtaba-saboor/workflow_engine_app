class Project < ApplicationRecord
  sequenceid :company, :projects
  PROJECT_CATEGORIES = %w[TEAM INDEPENDENT].freeze

  validates :name, presence: true, uniqueness: true
  validates :project_category, presence: true, inclusion: { in: PROJECT_CATEGORIES }
  validates :company_id, presence: true

  belongs_to :company

  has_many :project_teams, dependent: :destroy
  has_many :teams, through: :project_teams

  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users

  has_many :issues

  def valid_assignees
    members
  end

  def members
    if team_project?
      # User.joins(%(INNER JOIN `team_users`
      # ON `team_users`.`user_id` = `users`.`id` and `team_users`.`company_id` = #{company_id}
      # INNER JOIN `project_teams`
      # ON `project_teams`.`team_id` = `team_users`.`team_id` and `project_teams`.`project_id` = #{id})).distinct

      # This query has an extra inner join as compared to one above however it offers more readability, so it is used.
      # There is an extra inner join as joins works using associations and in above query we want to join two middle
      # tables so rails join them via the intermediate table
      teams.joins(:users).select('users.*').distinct
    else
      users
    end
  end

  def self.get_total_team_projects
    where(project_category: Project::PROJECT_CATEGORIES[0]).count
  end

  def team_project?
    project_category == PROJECT_CATEGORIES[0]
  end

  def available_users
    User.where.not(id: users.pluck(:id))
  end

  def available_teams
    Team.where.not(id: teams.pluck(:id))
  end
end
