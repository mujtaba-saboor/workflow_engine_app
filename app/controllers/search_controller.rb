class SearchController < ApplicationController
  # GET '/search', subdomain: /.+/
  def search
    @query = params[:query]

    @projects = @query.present? ? Project.accessible_by(current_ability, :read).where('projects.name LIKE ?', "%#{@query}%") : nil
  end
end
