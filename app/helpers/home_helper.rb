module HomeHelper
  def get_team_percentage(user)
    total_projects = user.get_project_count
    if(user.role.eql? 'STAFF')
      team_projects = user.projects.where(project_category: Project::PROJECT_CATEGORIES[0]).count
    else
      team_projects = Project.where(project_category: Project::PROJECT_CATEGORIES[0]).count
    end
    team_projects != 0 ? (team_projects * 100)/total_projects : 0
  end
end
