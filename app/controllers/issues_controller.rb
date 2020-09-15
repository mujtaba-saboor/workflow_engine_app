# frozen_string_literal: true

class IssuesController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource through: :project
  before_action :load_valid_assignees, only: %i[new edit update create]

  # project_issue GET /projects/:project_id/issues/:id(.:format)
  def show
    @comment = Comment.new
    @pagy, @comments = pagy(Comment.where(commentable: @issue))
    respond_to :html
  end

  # new_project_issue GET /projects/:project_id/issues/new(.:format)
  def new
    respond_to :html
  end

  # project_issues POST /projects/:project_id/(.:format)
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

  # edit_project_issue GET /projects/:project_id/issues/:id/edit(.:format)
  def edit
    respond_to :html
  end

  # project_issues PATCH /projects/:project_id/issues/:id(.:format)
  # project_issues PUT /projects/:project_id/issues/:id(.:format)
  def update
    respond_to do |format|
      if @issue.update(issue_params)
        format.html { redirect_to project_issue_path(@project, @issue) }
      else
        format.html { render 'edit' }
      end
    end
  end

  # project_issues DELETE /projects/:project_id/issues/:id(.:format)
  def destroy
    respond_to do |format|
      if @issue.destroy
        format.html { redirect_to project_path(params[:project_id]) }
      else
        format.html { redirect_back fallback_location: root_path }
      end
    end
  end

  private

  def load_valid_assignees
    @valid_assignees = @project.company.users
  end

  def issue_params
    params.require(:issue).permit(:title, :description, :issue_type, :priority, :status, :assignee_id)
  end
end
