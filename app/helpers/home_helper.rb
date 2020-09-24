module HomeHelper

  def get_team_percentage(user)
    total_projects = user.get_project_count
    if user.staff?
      team_projects = user.get_team_project_count
    else
      team_projects = Project.get_total_team_projects
    end
    team_projects != 0 ? (team_projects * 100) / total_projects : 0
  end
  
end
