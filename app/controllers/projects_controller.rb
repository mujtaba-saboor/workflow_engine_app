# frozen_string_literal: true

class ProjectsController < ApplicationController
  load_and_authorize_resource find_by: :sequence_num, through: :current_company

  before_action :load_pagy, only: %i[index]
  add_breadcrumb I18n.t('shared.home'), :root_path, only: [:index, :show]
  add_breadcrumb I18n.t('shared.projects'), :projects_path, only: [:index, :show]

  def index
    respond_to do |format|
      format.html
      format.js { render 'filters' }
    end
  end

  def new
    respond_to do |format|
      format.js
    end
  end

  def create
    if @project.save
      flash[:notice] = t('flash_messages.create', name: t('shared.project'))
      respond_to do |format|
        format.js { redirect_to project_path(@project) }
      end
    else
      respond_to do |format|
       format.js
      end
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    if @project.update(project_params)
      flash[:notice] = t('flash_messages.update', name: t('shared.project'))
      respond_to do |format|
        format.js { redirect_to project_path(@project) }
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def show
    add_breadcrumb @project.name, :project_path
    @pagy, @project_issues = pagy(@project.issues, link_extra: "data-remote='true'", items: Company::PAGE_SIZE)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    if @project.destroy
      flash[:notice] = t('flash_messages.destroy', name: t('shared.project'))
    else
      flash[:warning] = t('flash_messages.warning', warning_msg: t('projects.no_destroy'))
    end
    respond_to do |format|
      format.html { redirect_to projects_path }
    end
  end

  def filters
    if(params[:search].present?)
      if params[:search].eql? Project::PROJECT_CATEGORIES[0]
        @projects = @projects.team_projects
      elsif params[:search].eql? Project::PROJECT_CATEGORIES[1]
        @projects = @projects.independent_projects
      end
    end
    load_pagy
    respond_to do |format|
      format.js
    end
  end

  def project_users
    respond_to do |format|
      format.js
    end
  end

  def new_team_for_project
    respond_to do |format|
      format.js
    end
  end

  def add_team_to_project
    team = @current_company.teams.find_by_id params[:project][:team]
    if team.present?
      if ProjectTeam.create(project: @project, team: team)
        flash[:notice] = t('flash_messages.addition', name: t('shared.team'))
      else
        flash[:error] = t('flash_messages.error')
      end
    else
      flash[:error] = t('flash_messages.error')
    end

    respond_to do |format|
      format.js { redirect_to project_path(@project) }
    end
  end

  def remove_team_from_project
    team = @current_company.teams.find_by_sequence_num! params[:team]
    if team.present?
      if @project.teams.delete(team)
        flash[:notice] = t('flash_messages.deletion', name: t('shared.team'))
      else
        flash[:error] = t('flash_messages.error')
      end
    else
      flash[:error] = t('flash_messages.error')
    end

    respond_to do |format|
      format.html { redirect_to project_path(@project) }
    end
  end

  def new_user_for_project
    respond_to do |format|
      format.js
    end
  end

  def add_user_to_project
    user = @current_company.users.find_by_id params[:project][:user]

    if user.present?
      if ProjectUser.create(project: @project, user: user)
        flash[:notice] = t('flash_messages.addition', name: t('shared.user'))
      else
        flash[:error] = t('flash_messages.error')
      end
    else
      flash[:error] = t('flash_messages.error')
    end

    respond_to do |format|
      format.js { redirect_to project_path(@project) }
    end
  end

  def remove_user_from_project
    user = @current_company.users.find_by_sequence_num! params[:user]
    if user.present?
      if @project.users.delete(user)
        flash[:notice] = t('flash_messages.deletion', name: t('shared.user'))
      else
        flash[:error] = t('flash_messages.error')
      end
    else
      flash[:error] = t('flash_messages.error')
    end

    respond_to do |format|
      format.html { redirect_to project_path(@project) }
    end
  end

  private

  def load_pagy
    @pagy, @projects = pagy(@projects.order(created_at: :desc), link_extra: "data-remote='true'", items: Company::PAGE_SIZE)
  end

  def project_params
    params.require(:project).permit(:name, :project_category)
  end
end
