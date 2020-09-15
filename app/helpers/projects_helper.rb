module ProjectsHelper
  def project_teams(project)
    Team.where.not(id: project.teams.select(:id))
  end

  def is_team_available?(project)
    Team.where.not(id: project.teams.select(:id)).to_a.empty?
  end

  def project_display_name(project)
    project.project_category == 'TEAM' ? 'TEAMS' : 'MEMBERS'
  end

  def is_user_available?(project)
    User.where.not(id: project.users.select(:id)).to_a.empty?
  end

  def project_users(project)
    User.where.not(id: project.users.select(:id))
  end
end
