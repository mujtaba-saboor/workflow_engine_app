module ApplicationHelper
  include Pagy::Frontend
  
  def get_top_nav_links
    { t('shared.home')=> '#', t('shared.about') => '#', t('shared.contact_us') => '#' }
  end

  def get_sidebar_links
    { t('shared.home')=> root_path, t('shared.projects') => projects_path, t('shared.teams') => teams_path }
  end
  
  def get_active_nav(controller)       
    params[:controller] == controller ? 'active' : nil       
  end
end
