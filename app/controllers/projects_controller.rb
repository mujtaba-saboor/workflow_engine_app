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

  def new_team
    @project = Project.find(params[:id])
  end

  def create_team
    company = Company.first
    project = Project.find(params[:id])
    team = Team.find(params[:project][:team])
    result  = ProjectTeam.create(project: project,team: team, company: company)
    if(result)
      flash[:notif] = 'Team Added Successfully'
      redirect_to project_path(project)
    else
    end
  end

  def remove_team
    project = Project.find(params[:id])
    team = Team.find(params[:team])
    result  = project.teams.delete(team)
    if(result)
      flash[:notif] = 'Team Removed Successfully'
      redirect_to project_path(project)
    else
    end
  end

  private
  def project_params
    params.require(:project).permit(:name, :project_category)
  end
end
