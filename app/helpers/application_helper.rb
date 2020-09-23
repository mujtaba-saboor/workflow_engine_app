module ApplicationHelper
  include Pagy::Frontend

  def bootstrap_color_for_alert(alert_type)
    case alert_type
    when 'error'
      'danger'
    when 'notice'
      'success'
    else
      'info'
    end
  end

  def get_top_nav_links
    { t('shared.home') => root_url, t('shared.about') => about_url, t('shared.contact_us') => contact_us_url }
  end

  def get_sidebar_links
    { t('shared.home') => root_path, t('shared.projects') => projects_path, t('shared.teams') => teams_path }
  end

  def get_active_nav(controller)
    params[:controller] == controller ? 'active' : nil
  end
end
