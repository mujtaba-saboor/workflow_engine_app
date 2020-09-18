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
      flash[:success] = t('flash_messages.create', name: t('projects.project'))
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
      flash[:success] = t('flash_messages.update', name: t('projects.project'))
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
      flash[:success] = t('flash_messages.destroy', name: t('projects.project'))
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
<<<<<<< HEAD

    team = Team.find_by params[:project][:team]
    if ProjectTeam.create(project: @project, team: team, company: company)
      flash[:success] = t('flash_messages.addition', name: 'Team')
=======
    team = Team.find_by_id params[:project][:team]
    unless team.nil?
      if ProjectTeam.create(project: @project, team: team, company: company)
        flash[:success] = t('flash_messages.addition', name: t('projects.team'))
      else
        flash[:danger] = t('flash_messages.error')
      end
>>>>>>> fb0cc72512890d2c0e1bd5b1834611ceae2da18d
    else
      flash[:danger] = t('flash_messages.error')
    end
    
    respond_to do |format|
      format.js { redirect_to project_path(@project) }
    end
  end

  def remove_team_from_project
    team = Team.find_by_id params[:team]
    
    unless team.nil?
      if @project.teams.delete(team)
        flash[:success] = t('flash_messages.deletion', name: t('projects.team'))
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
    
    unless user.nil?
      if ProjectUser.create(project: @project, user: user, company: company)
        flash[:success] = t('flash_messages.addition', name: t('projects.user'))
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
    
    unless user.nil?
      if @project.users.delete(user)
        flash[:success] = t('flash_messages.deletion', name: t('projects.user'))
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