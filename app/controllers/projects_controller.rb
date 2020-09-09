class ProjectsController < ApplicationController
  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    compnay = Company.first
    @project = Project.new
    @project.name = params[:project][:name]
    @project.project_category = params[:project][:project_category]
    @project.company = compnay
    #project = Project.create(project_params)    
    if(@project.save)
      flash[:notif] = 'Project Created Successfully'      
    else
      flash[:notif] = 'An Error Occured'    
    end
    redirect_to projects_path
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    project = Project.find(params[:id])
    project.update(project_params)
    redirect_to projects_path
  end

  def show
    @project = Project.find(params[:id])
  end

  def destroy
    project = Project.find(params[:id])
    project.destroy
    redirect_to projects_path
  end

  def project_users
    @project = Project.find(params[:id])
  end

  def add_user
  end

  def add_team
    @project = Project.find(params[:id])
  end

  private
  def project_params
    params.require(:project).permit(:name, :project_category)
  end
end
