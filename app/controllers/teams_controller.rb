class TeamsController < ApplicationController
  def index
    @teams = Team.all
  end

  def new
    @team = Team.new
  end

  def create
    compnay = Company.first
    @team = Team.new
    @team.name = params[:team][:name]    
    @team.company = compnay
    #project = Project.create(project_params)    
    if(@team.save)
      flash.now[:notif] = 'Project Created Successfully'      
    else
      flash.now[:notif] = 'An Error Occured'    
    end
    redirect_to teams_path
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    team = Team.find(params[:id])
    team.update(team_params)
    redirect_to teams_path
  end

  def show
    @team = Team.find(params[:id])
  end

  def destroy
    team = Team.find(params[:id])
    team.destroy
    redirect_to teams_path
  end

  def new_member
    @team = Team.find(params[:id])    
  end

  def create_member
    company = Company.first
    team = Team.find(params[:id])
    user = User.find(params[:team][:user])
    result  = TeamUser.create(team: team,user: user, company: company)
    if(result)
      flash[:notif] = 'User Added Successfully'
      redirect_to team_path(team)
    else
    end  end

  def remove_member
    puts "+++++#{params}"
     team = Team.find(params[:id])
    user = User.find(params[:user])
    result  = team.users.delete(user)
    if(result)
      flash[:notif] = 'User Removed Successfully'
      redirect_to team_path(team)
    else
    end
    
  end

  private
  def team_params
    params.require(:team).permit(:name)
  end
end
