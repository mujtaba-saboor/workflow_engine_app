module HomeHelper
  def get_team_percentage
    total_projects = Project.all.count
    team_projects = Project.where(project_category: 'TEAM').count
    team_projects != 0 ? team_projects = (team_projects * 100)/total_projects : 0
  end
  def get_individual_percentage
    total_projects = Project.all.count
    individual_projects = Project.where(project_category: 'INDIVIDUAL').count
    individual_projects != 0 ? individual_projects = (individual_projects * 100)/total_projects : 0
  end
end
