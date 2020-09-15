module ProjectsHelper
  def project_teams(project)
    Team.where.not(id: project.teams.select(:id))
  end

  def is_team_available?(project)
    Team.where.not(id: project.teams.select(:id)).to_a.empty?
  end

  def project_display_name(project)
    project_categories = Project.project_categories
    project.project_category == project_categories[0] ? project_categories[0] : project_categories[1]
  end

  def is_user_available?(project)
    User.where.not(id: project.users.select(:id)).to_a.empty?
  end

  def project_users(project)
    User.where.not(id: project.users.select(:id))
  end
end
