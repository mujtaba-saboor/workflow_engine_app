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
    @team.company = company
    if @team.save
      flash[:success] = t('flash_messages.create', name: 'Team')
    else
      flash[:danger] = t('flash_messages.error', error_msg: @team.errors.full_messages.first)
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
    if @team.update(team_params)
      flash[:success] = t('flash_messages.update', name: 'Team')
    else
      flash[:danger] = t('flash_messages.error', error_msg: @team.errors.full_messages.first)
    end
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
    team_project = ProjectTeam.where(team: @team)

    if team_project.empty?
      @team.destroy
      flash[:success] = t('flash_messages.destroy', name: 'Team')
    else
      flash[:warning] = t('flash_messages.warning', warning_msg: "Team can not be deleted because its a part of #{team_project[0].project.name}")
    end
    respond_to do |format|
      format.html { redirect_to teams_path }
    end
  end

  def new_user
    respond_to do |format|
      format.js
    end
  end

  def add_user_to_team
    company = Company.first
    user = User.find(params[:team][:user])

    if TeamUser.create(team: @team, user: user, company: company)
      flash[:success] = t('flash_messages.addition', name: 'User')
    else
      flash[:danger] = t('flash_messages.error')
    end
    respond_to do |format|
      format.js { redirect_to team_path(@team) }
    end
  end

  def remove_user_from_team
    user = User.find(params[:user])

    if @team.users.delete(user)
      flash[:success] = t('flash_messages.deletion', name: 'User')
    else
      flash[:danger] = t('flash_messages.error')
    end
    respond_to do |format|
      format.html { redirect_to team_path(@team) }
    end
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end
end
