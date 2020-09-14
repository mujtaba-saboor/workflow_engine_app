module ApplicationHelper
  include Pagy::Frontend
  def pagy_url_for(page, pagy, url=false)
    path = pagy.instance_variable_get(:@custom_link)
    path ||= request.path

    puts path

    p_vars = pagy.vars; params = request.GET.merge(p_vars[:params]); params[p_vars[:page_param].to_s] = page
    "#{request.base_url if url}#{path}?#{Rack::Utils.build_nested_query(pagy_get_params(params))}#{p_vars[:anchor]}"
  end
end
