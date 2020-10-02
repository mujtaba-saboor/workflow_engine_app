# frozen_string_literal: true

class SearchController < ApplicationController
  add_breadcrumb I18n.t('shared.home'), :root_path

  # GET '/search'
  def search
    add_breadcrumb t('search.search')
    @query = params[:query]
    return if @query.blank?

    @users    =  @current_company.users.accessible_by(current_ability, :read).where('users.name LIKE :query OR users.email LIKE :query', query: "%#{@query}%")
    @projects =  @current_company.projects.accessible_by(current_ability, :read).where('projects.name LIKE :name', name: "%#{@query}%")
    @issues   =  @current_company.issues.accessible_by(current_ability, :read).where('issues.title LIKE :title', title: "%#{@query}%")

    respond_to do |format|
      format.html
    end
  end
end
