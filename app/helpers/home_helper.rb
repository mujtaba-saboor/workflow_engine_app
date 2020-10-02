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
  
  def high_issues_percentage(user)
    issues = user.all_issues
    total_issues = issues.count
    high_priority_issues = issues.where(issues: { priority: Issue.priorities[:high] }).count
    high_priority_issues != 0 ? (high_priority_issues * 100) / total_issues : 0
  end

  def issues_percentage(user)    
    
    issues = user.all_issues
    total_issues = issues.count

    status_percentages = {}
    statuses = Issue.statuses.keys
    statuses.each do |status|
      issues_by_status = issues.where(issues: { status: "#{status}" }).count
      status_percentages[:"#{status}"] = total_issues != 0 ? (issues_by_status * 100) / total_issues : 0
    end
    status_percentages
  end  
end
