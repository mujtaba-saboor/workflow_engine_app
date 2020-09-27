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
    { t('shared.home') => '#home_section', t('shared.features') => '#features_section', t('shared.about') => '#about_section' }
  end

  def get_sidebar_links
    { t('shared.home') => root_path, t('shared.projects') => projects_path, t('shared.teams') => teams_path }
  end

  def get_active_nav(controller)
    params[:controller] == controller ? 'active' : nil
  end
end
