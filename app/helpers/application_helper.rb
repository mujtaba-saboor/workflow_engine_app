module ApplicationHelper
  include Pagy::Frontend

  # This helper method overrides the helper method with same name for pagy gem
  # This override gives facility to provide a base path for the pagy links via the 'custom_link' instance variable
  def pagy_url_for(page, pagy, url=false)
    path = pagy.instance_variable_get(:@custom_link)
    path ||= request.path

    p_vars = pagy.vars; params = request.GET.merge(p_vars[:params]); params[p_vars[:page_param].to_s] = page
    "#{request.base_url if url}#{path}?#{Rack::Utils.build_nested_query(pagy_get_params(params))}#{p_vars[:anchor]}"
  end
end
