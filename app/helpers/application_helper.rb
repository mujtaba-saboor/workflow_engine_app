module ApplicationHelper
  def get_top_nav_links
    {t('shared.home')=> root_path, t('shared.projects') => projects_path, t('shared.teams') => teams_path}
  end

  def get_sidebar_links
    {t('shared.home')=> root_path, t('shared.projects') => projects_path, t('shared.teams') => teams_path}    
  end
  
  def is_active(controller)       
    params[:controller] == controller ? "active" : nil        
  end
end
