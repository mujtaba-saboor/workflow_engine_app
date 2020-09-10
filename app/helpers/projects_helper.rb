module ProjectsHelper
  def project_teams(project)
    Team.where.not(id: project.teams.select(:id)) 
  end

  def isTeamAvailable?(project)
    Team.where.not(id: project.teams.select(:id)).to_a.empty?
  end

  def project_display_name(project)
    display_name = nil
    if project.project_category == 'TEAM'
      display_name = 'TEAMS'
    else
      display_name = 'MEMBERS'
    end
    display_name
  end
end

