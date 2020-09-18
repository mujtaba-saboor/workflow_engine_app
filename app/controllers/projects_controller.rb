class ProjectsController < ApplicationController
  load_and_authorize_resource
  def index
    respond_to do |format|
      format.html
    end
  end

  def new
    respond_to do |format|
      format.js
    end
  end

  def create
    company = Company.first
    @project.company = company

    if @project.save
      flash[:success] = t('flash_messages.create', name: t('shared.project'))
    else
      flash[:danger] = t('flash_messages.error', error_msg: @project.errors.full_messages.first)
    end

    respond_to do |format|
      format.js { redirect_to projects_path }
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    if @project.update(project_params)  
      flash[:success] = t('flash_messages.update', name: t('shared.project'))
    else
      flash[:danger] = t('flash_messages.error', error_msg: @project.errors.full_messages.first)
    end
    respond_to do |format|
      format.js { redirect_to projects_path }
    end
  end

  def show
    respond_to do |format|
      format.html
    end
  end

  def destroy
    if @project.destroy
      flash[:success] = t('flash_messages.destroy', name: t('shared.project'))
    else
      flash[:warning] = t('flash_messages.warning', warning_msg: t('projects.no_destroy'))
    end
    respond_to do |format|
      format.html { redirect_to projects_path }
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
    company = Company.first
    team = Team.find_by_id params[:project][:team]
    if team.present?
      if ProjectTeam.create(project: @project, team: team, company: company)
        flash[:success] = t('flash_messages.addition', name: t('shared.team'))
      else
        flash[:danger] = t('flash_messages.error')
      end
    else
      flash[:danger] = t('flash_messages.error')
    end
    
    respond_to do |format|
      format.js { redirect_to project_path(@project) }
    end
  end

  def remove_team_from_project
    team = Team.find_by_id params[:team]
    
    if team.present?
      if @project.teams.delete(team)
        flash[:success] = t('flash_messages.deletion', name: t('shared.team'))
      else
        flash[:danger] = t('flash_messages.error')
      end
    else
      flash[:danger] = t('flash_messages.error')
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
    company = Company.first
    user = User.find(params[:project][:user])
    
    if user.present?
      if ProjectUser.create(project: @project, user: user, company: company)
        flash[:success] = t('flash_messages.addition', name: t('shared.user'))
      else
        flash[:danger] = t('flash_messages.error')
      end
    else
      flash[:danger] = t('flash_messages.error')
    end
    
    respond_to do |format|
      format.js { redirect_to project_path(@project) }
    end
  end

  def remove_user_from_project
    user = User.find(params[:user])
    
    if user.present?
      if @project.users.delete(user)
        flash[:success] = t('flash_messages.deletion', name: t('shared.user'))
      else
        flash[:danger] = t('flash_messages.error')
      end
    else
      flash[:danger] = t('flash_messages.error')
    end

    respond_to do |format|
      format.html { redirect_to project_path(@project) }
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :project_category)
  end
end