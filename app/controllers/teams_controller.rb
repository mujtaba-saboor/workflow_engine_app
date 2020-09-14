class TeamsController < ApplicationController
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
    @team.name = params[:team][:name]
    @team.company = company
    if @team.save
      flash[:success] = 'Team Created Successfully'
    else
      flash[:danger] = 'An Error Occured'
    end

    respond_to do |format|
      format.js { redirect_to teams_path }
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    @team.update(team_params)
    flash[:success] = 'Team Updated Successfully'

    respond_to do |format|
      format.js { redirect_to teams_path }
    end
  end

  def show
    respond_to do |format|
      format.html
    end
  end

  def destroy
    @team.destroy
    flash[:danger] = 'Team Destroyed Successfully'
    respond_to do |format|
      format.html { redirect_to teams_path }
    end
  end

  def new_member
    respond_to do |format|
      format.js
    end
  end

  def create_member
    company = Company.first
    user = User.find(params[:team][:user])
    result = TeamUser.create(team: @team, user: user, company: company)
    
    if result
      flash[:success] = 'User Added Successfully'
    else
      flash[:danger] = 'An Error Occured'
    end
    respond_to do |format| 
      format.js { redirect_to team_path(@team) }
    end
  end

  def remove_member
    user = User.find(params[:user])
    result = @team.users.delete(user)
    
    if result
      flash[:danger] = 'User Removed Successfully'
    else
      flash[:danger] = 'An Error Occured'
    end
    respond_to do |format|
      format.html { redirect_to team_path(@team) }
    end
  end

  def remove
    team_project = ProjectTeam.where(team: @team)
    
    if team_project.empty?
      @team.destroy
      flash[:danger] = 'Team Destroyed Successfully'
    else
      flash[:warning] = "Team can not be deleted because its a part of #{team_project[0]}"
    end
    respond_to do |format|
      format.html { redirect_to teams_path }
    end
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end
end
