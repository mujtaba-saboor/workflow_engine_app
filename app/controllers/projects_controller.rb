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
    compnay = Company.first
    @project.name = params[:project][:name]
    @project.project_category = params[:project][:project_category]
    @project.company = compnay
    respond_to do |format|
      if @project.save
        flash[:success] = 'Project Created Successfully'
      else
        flash[:danger] = 'An Error Occured'
      end
      redirect_to projects_path
      format.js
    end
  end

  def edit  
    respond_to do |format|
      format.js
    end
  end

  def update
    @project.update(project_params)
    respond_to do |format|
      flash[:success] = 'Project Updated Successfully'
      redirect_to projects_path
      format.js
    end
  end

  def show
    respond_to do |format|
      format.html
    end
  end

  def destroy
    @project.destroy
    respond_to do |format|
      flash[:danger] = 'Project Destroyed Successfully'
      redirect_to projects_path
      format.html
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

  def create_team
    company = Company.first
    team = Team.find(params[:project][:team])
    result = ProjectTeam.create(project: @project, team: team, company: company)
    respond_to do |format|
      if result
        flash[:success] = 'Team Added Successfully'
      else
        flash[:danger] = 'An Error Occured'
      end
      redirect_to project_path(@project)
      format.js
    end   
  end

  def remove_team
    team = Team.find(params[:team])
    result = @project.teams.delete(team)
    respond_to do |format|
      if result
        flash[:danger] = 'Team Removed Successfully'
      else
        flash[:danger] = 'An Error Occured'
      end
      redirect_to project_path(@project)
      format.html
    end
  end

  def new_user
    respond_to do |format|
      format.js
    end
  end

  def create_user
    company = Company.first    
    user = User.find(params[:project][:user])
    result = ProjectUser.create(project: @project, user: user, company: company)
    respond_to do |format|
      if result
        flash[:success] = 'User Added Successfully'
      else
        flash[:danger] = 'An Error Occured'
      end
      redirect_to project_path(@project)
      format.js
    end
  end

  def remove_user
    user = User.find(params[:user])
    result = @project.users.delete(user)
    respond_to do |format|
      if result
        flash[:danger] = 'User Removed Successfully'
      else
        flash[:danger] = 'An Error Occured'
      end
      redirect_to project_path(@project)
      format.html
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :project_category)
  end
end
