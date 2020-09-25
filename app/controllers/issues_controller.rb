# frozen_string_literal: true

class IssuesController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource through: :project
  before_action :load_valid_assignees, only: %i[new edit update create]
  before_action :load_issue_watcher, only: %i[show update_status]

  # GET /projects/:project_id/issues/:id
  def show
    @comment = Comment.new
    @pagy, @comments = pagy(Comment.where(commentable: @issue))
    respond_to do |format|
      format.html
    end
  end

  # GET /projects/:project_id/issues/new
  def new
    respond_to do |format|
      format.html
    end
  end

  # POST /projects/:project_id/issues
  def create
    # Here the company is being set via the cancancan ability written as,
    # can :create, Issue, company_id: user.company_id

    # Similar is the case for user
    # can :create, Issue, creator_id: user.id

    # Project for the issue is also set automatically here via the cancancan load_and_authorize statements
    # as given above

    respond_to do |format|
      if @issue.save
        format.html { redirect_to project_issue_path(@project, @issue) }
      else
        format.html { render 'new' }
      end
    end
  end

  # GET /projects/:project_id/issues/:id/edit
  def edit
    respond_to do |format|
      format.html
    end
  end

  # PATCH /projects/:project_id/issues/:id(.:format)
  # PUT /projects/:project_id/issues/:id(.:format)
  def update
    respond_to do |format|
      if @issue.update(issue_params)
        format.html { redirect_to project_issue_path(@project, @issue) }
      else
        format.html { render 'edit' }
      end
    end
  end

  # DELETE /projects/:project_id/issues/:id
  def destroy
    respond_to do |format|
      if @issue.destroy
        format.html { redirect_to project_path(params[:project_id]) }
      else
        format.html { redirect_back fallback_location: root_path }
      end
    end
  end

  # PATCH /projects/:project_id/issues/:id/update_status
  def update_status
    event_str = params[:status]

    if Issue::AASM_EVENTS_HUMANIZED.include?(event_str) && (update_event = @issue.aasm.events(permitted: true).find { |event| event.name.to_s.humanize == event_str })
      @issue.public_send("#{update_event.name}!")

      # Send mail to watchers
      @issue.inform_status_change

      # TODO: Change the internationalization method for aasm states from enum type internationalization mechanism to
      # aasm I18n internationalization
      flash.now[:notice] = t('issues.update_status.success', new_status: Issue.human_enum_name(:status, @issue.status))
    else
      flash.now[:error] = t('issues.update_status.failure')
    end

    respond_to do |format|
      format.js
    end
  end

  private

  def load_valid_assignees
    @valid_assignees = @project.valid_assignees
  end

  def load_issue_watcher
    @watcher = current_user.watcher_for(@issue)
  end

  def issue_params
    params.require(:issue).permit(:title, :description, :issue_type, :priority, :status, :assignee_id, documents: [])
  end
end
