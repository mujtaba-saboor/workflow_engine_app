class SearchController < ApplicationController
  # GET '/search', subdomain: /.+/
  def search
    @query = params[:query]
    @query_regex = /#{@query}/i

    return if @query.blank?
    @users    =  @current_company.users.accessible_by(current_ability, :read).where('users.name LIKE :query OR users.email LIKE :query', query: "%#{@query}%")
    @projects =  @current_company.projects.accessible_by(current_ability, :read).where('projects.name LIKE :name', name: "%#{@query}%")
    @issues_pagy, @issues   =  pagy(@current_company.issues.accessible_by(current_ability, :read).where('issues.title LIKE :title', title: "%#{@query}%"))

    respond_to do |format|
      format.html
    end
  end
end
