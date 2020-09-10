class IssuesController < ApplicationController
  def show
    @issue = Issue.find_by!(id: params[:id], project_id: params[:project_id])
    @comment = Comment.new
    @comments = Comment.where(commentable: @issue)
  end

  def new
    @project = Project.find(params[:project_id])
    @issue = Issue.new
    @valid_assignees = @project.company.users
  end

  def create
    @project = Project.find(params[:project_id])
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
    @issue = Issue.find_by!(id: params[:id], project_id: params[:project_id])
    @project = @issue.project
    @issue = Issue.find(params[:id])
    @valid_assignees = @project.company.users
  end

  def update
    @issue = Issue.find_by!(id: params[:id], project_id: params[:project_id])
    @project = @issue.project

    if @issue.update(issue_params)
      redirect_to project_issue_path(@project, @issue)
    else
      @valid_assignees = @project.company.users
      render 'edit'
    end
  end

  def destroy
    @issue = Issue.find_by!(id: params[:id], project_id: params[:project_id])
    @issue.destroy
    redirect_to project_path(params[:project_id])
  end

  private

  def issue_params
    params.require(:issue).permit(:title, :description, :issue_type, :priority, :status, :assignee_id)
  end
end
