class TeamsController < ApplicationController
  load_and_authorize_resource find_by: :sequence_num, through: :current_company

  before_action :load_pagy, only: %i[index]

  add_breadcrumb I18n.t('shared.home'), :root_path, only: [:index, :show]
  add_breadcrumb I18n.t('shared.teams'), :teams_path, only: [:index, :show]

  def index
    respond_to do |format|
      format.html
      format.js
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
      respond_to do |format|
        format.js
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
      respond_to do |format|
        format.js { redirect_to team_path(@team) }
      end
    else
      respond_to do |format|
        format.js
      end
    end
    
  end

  def show
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
      respond_to do |format|
        format.html { redirect_to teams_path }
      end
    else
      flash[:warning] = t('flash_messages.warning', warning_msg: t('teams.no_deletion_warning'))
      respond_to do |format|
        format.html { redirect_to team_path(@team) }
      end
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
    user = @current_company.users.find_by_sequence_num! params[:user]

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

  def load_pagy
    @pagy, @teams = pagy(@teams.order(created_at: :desc),link_extra: "data-remote='true'", items: Company::PAGE_SIZE)
  end

  def team_params
    params.require(:team).permit(:name)
  end
end
