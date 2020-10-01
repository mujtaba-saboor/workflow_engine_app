module ApplicationHelper
  include Pagy::Frontend

  # This helper method overrides the helper method with same name for pagy gem
  # This override gives facility to provide a base path for the pagy links via the 'custom_link' instance variable
  def pagy_url_for(page, pagy, url = false)
    path = pagy.instance_variable_get(:@custom_link)
    path ||= request.path

    p_vars = pagy.vars; params = request.GET.merge(p_vars[:params]); params[p_vars[:page_param].to_s] = page
    "#{request.base_url if url}#{path}?#{Rack::Utils.build_nested_query(pagy_get_params(params))}#{p_vars[:anchor]}"
  end

  def get_top_nav_links
    {
      t('shared.home') => "#{root_url}#home_section",
      t('shared.features') => "#{root_url}#features_section",
      t('shared.about') => "#{root_url}#about_section"
    }
  end

  def get_sidebar_links
    {
      t('shared.home') => { path: root_path, icon: 'fas fa-home' },
      t('shared.projects') => {path: projects_path, icon: 'fas fa-project-diagram' },
      t('shared.issues') => {path: issues_path, icon: 'fas fa-clipboard-list' },
      t('shared.teams') => { path: teams_path, icon: 'fas fa-users-cog' },
      t('shared.users') => {path: users_path, icon: 'fas fa-users'} 
    }
  end

  def get_active_nav(controller)
    params[:controller] == controller || (params[:controller].eql? 'companies' and controller.eql? 'home') ? 'active' : nil
  end

  def bootstrap_color_class_for_alert_type(alert_type)
    case alert_type
      when 'notice'
        'success'
      when 'error'
        'danger'
      else
        alert_type
    end
  end
end
