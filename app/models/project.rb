class Project < ApplicationRecord
  belongs_to :company

  has_many :project_teams
  has_many :teams, through: :project_teams

  has_many :project_users
  has_many :users, through: :project_users

  has_many :issues

  def valid_assignees
    if project_category == 'TEAM'
      User.joins(%(INNER JOIN `team_users`
      ON `team_users`.`user_id` = `users`.`id` and `team_users`.`company_id` = #{company_id}
      INNER JOIN `project_teams`
      ON `project_teams`.`team_id` = `team_users`.`team_id` and `project_teams`.`project_id` = #{id})).distinct
    else
      company.users
    end
  end
end
