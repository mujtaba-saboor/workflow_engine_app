class ProjectsController < ApplicationController
  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    project = Project.create(project_params)
    if(project)
      redirect_to projects_path
    else
      redirect_to projects_path
    end
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

  private
  def project_params
    params.require(:project).permit(:name, :project_category)
  end
end
