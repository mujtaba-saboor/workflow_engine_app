# frozen_string_literal: true

class SearchController < ApplicationController
  add_breadcrumb I18n.t('shared.home'), :root_path

  # GET '/search'
  def search
    add_breadcrumb t('search.search')
    @query = params[:query]
    return if @query.blank?

    search_users
    search_projects
    search_issues

    Searchkick.multi_search([@users, @projects, @issues])

    @users_pagy = Pagy.new_from_searchkick(@users, page_param: :users_page)
    @projects_pagy = Pagy.new_from_searchkick(@projects, page_param: :projects_page)
    @issues_pagy = Pagy.new_from_searchkick(@issues, page_param: :issues_page)

    respond_to do |format|
      format.html
    end
  end

  private

  def search_users
    @users = User.search(
      @query,
      fields: %i[name email],
      where: { id: @current_company.users.accessible_by(current_ability, :read).pluck(:id) },
      page: params[:users_page],
      per_page: Pagy::VARS[:items],
      match: :word_middle,
      execute: false
    )
  end

  def search_projects
    @projects = Project.search(
      @query,
      fields: %i[name],
      where: { id: @current_company.projects.accessible_by(current_ability, :read).pluck(:id) },
      page: params[:projects_page],
      per_page: Pagy::VARS[:items],
      execute: false
    )
  end

  def search_issues
    @issues = Issue.search(
      @query,
      fields: %w[title^5 description],
      where: { id: @current_company.issues.accessible_by(current_ability, :read).pluck(:id) },
      page: params[:issues_page],
      per_page: Pagy::VARS[:items],
      execute: false
    )
  end
end
