class TeamsController < ApplicationController
  load_and_authorize_resource find_by: :sequence_num, through: :current_company
  def index
    add_breadcrumb t('shared.home'), :root_path
    add_breadcrumb t('shared.teams'), :teams_path
    @pagy, @teams = pagy(@teams.order(created_at: :desc), items: Company::PAGE_SIZE)
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
    if @team.save
      flash[:success] = t('flash_messages.create', name: t('shared.team'))
      respond_to do |format|
        format.js { redirect_to team_path(@team) }
      end
    else
      flash[:danger] = t('flash_messages.error', error_msg: @team.errors.full_messages.first)
      respond_to do |format|
        format.js { redirect_to teams_path }
      end
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    if @team.update(team_params)
      flash[:success] = t('flash_messages.update', name: t('shared.team'))
    else
      flash[:danger] = t('flash_messages.error', error_msg: @team.errors.full_messages.first)
    end
    respond_to do |format|
      format.js { redirect_to teams_path }
    end
  end

  def show
    add_breadcrumb t('shared.home'), :root_path
    add_breadcrumb t('shared.teams'), :teams_path
    add_breadcrumb @team.name, :team_path
    respond_to do |format|
      format.html
    end
  end

  def destroy
    team_project = @team.project_teams

    if team_project.empty?
      @team.destroy
      flash[:success] = t('flash_messages.destroy', name: t('shared.team'))
    else
      flash[:warning] = t('flash_messages.warning', warning_msg: t('teams.no_deletion_warning'))
    end

    respond_to do |format|
      format.html { redirect_to teams_path }
    end
  end

  def new_user_for_team
    respond_to do |format|
      format.js
    end
  end

  def add_user_to_team
    user = @current_company.users.find_by_id params[:team][:user]

    if user.present?
      if TeamUser.create(team: @team, user: user)
        flash[:success] = t('flash_messages.addition', name: t('shared.user'))
      else
        flash[:danger] = t('flash_messages.error')
      end
    else
      flash[:danger] = t('flash_messages.error')
    end
    respond_to do |format|
      format.js { redirect_to team_path(@team) }
    end
  end

  def remove_user_from_team
    user = @current_company.users.find_by_id params[:user]

    if user.present?
      if @team.users.delete(user)
        flash[:success] = t('flash_messages.deletion', name: t('shared.user'))
      else
        flash[:danger] = t('flash_messages.error')
      end
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
