class IssuesController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource through: :project

  def show
    @comment = Comment.new
    @pagy, @comments = pagy(Comment.where(commentable: @issue))
    p @pagy
  end

  def new
    @valid_assignees = @project.company.users
  end

  def create
    @issue = Issue.new(issue_params)

    @issue.creator = current_user
    @issue.company = current_user.company
    @issue.project = @project

    if @issue.save
      redirect_to project_issue_path(@project, @issue)
    else
      @valid_assignees = @project.company.users
      render 'new'
    end
  end

  def edit
    @valid_assignees = @project.company.users
  end

  def update
    if @issue.update(issue_params)
      redirect_to project_issue_path(@project, @issue)
    else
      @valid_assignees = @project.company.users
      render 'edit'
    end
  end

  def destroy
    @issue.destroy
    redirect_to project_path(params[:project_id])
  end

  private

  def issue_params
    params.require(:issue).permit(:title, :description, :issue_type, :priority, :status, :assignee_id)
  end
end
