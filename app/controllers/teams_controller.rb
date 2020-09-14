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
    compnay = Company.first
    @team.name = params[:team][:name]
    @team.company = compnay
    respond_to do |format|
      if @team.save
        flash[:success] = 'Team Created Successfully'
      else
        flash[:danger] = 'An Error Occured'
      end
      redirect_to teams_path
      format.js
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    @team.update(team_params)
    respond_to do |format|
      flash[:success] = 'Team Updated Successfully'
      redirect_to teams_path
      format.js
    end
  end

  def show
    respond_to do |format|
      format.html
    end
  end

  def destroy
    @team.destroy
    respond_to do |format|
      flash[:danger] = 'Team Destroyed Successfully'
      redirect_to teams_path
      format.html
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
    respond_to do |format|
      if result
        flash[:success] = 'User Added Successfully'
      else
        flash[:danger] = 'An Error Occured'
      end
      redirect_to team_path(@team)
      format.js
    end
  end

  def remove_member
    user = User.find(params[:user])
    result = @team.users.delete(user)
    respond_to do |format|
      if result
        flash[:danger] = 'User Removed Successfully'
      else
        flash[:danger] = 'An Error Occured'
      end
      redirect_to team_path(@team)
      format.html
    end
  end

  def remove
    team_project = ProjectTeam.where(team: @team)
    respond_to do |format|
      if team_project.empty?
        @team.destroy
        flash[:danger] = 'Team Destroyed Successfully'
      else
        flash[:warning] = "Team can not be deleted because its a part of #{team_project[0]}"
      end
      redirect_to teams_path
      format.html
    end
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end
end
