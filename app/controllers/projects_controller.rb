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
      flash[:success] = 'Project Created Successfully'
    else
      flash[:danger] = 'An Error Occured'
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
      flash[:success] = 'Project Updated Successfully'
    else
      flash[:danger] = 'An Error Occured'
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
      flash[:success] = 'Project Destroyed Successfully'
    else
      flash[:warning] = "Project can't be Destroyed"
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

  def new_team
    respond_to do |format|
      format.js
    end
  end

  def add_team_to_project
    company = Company.first

    team = Team.find(params.require(:project).permit(:team).require(:team))
    if ProjectTeam.create(project: @project, team: team, company: company)
      flash[:success] = 'Team Added Successfully'
    else
      flash[:danger] = 'An Error Occured'
    end
    respond_to do |format|
      format.js { redirect_to project_path(@project) }
    end
  end

  def remove_team_from_project
    team = Team.find(params.permit(:team).require(:team))
    if @project.teams.delete(team)
      flash[:success] = 'Team Removed Successfully'
    else
      flash[:danger] = 'An Error Occured'
    end
    respond_to do |format|
      format.html { redirect_to project_path(@project) }
    end
  end

  def new_user
    respond_to do |format|
      format.js
    end
  end

  def add_user_to_project
    company = Company.first
    user = User.find(params[:project][:user])

    if ProjectUser.create(project: @project, user: user, company: company)
      flash[:success] = 'User Added Successfully'
    else
      flash[:danger] = 'An Error Occured'
    end
    respond_to do |format|
      format.js { redirect_to project_path(@project) }
    end
  end

  def remove_user_from_project
    user = User.find(params[:user])

    if @project.users.delete(user)
      flash[:success] = 'User Removed Successfully'
    else
      flash[:danger] = 'An Error Occured'
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
