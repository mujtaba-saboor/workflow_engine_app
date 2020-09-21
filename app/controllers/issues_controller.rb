class IssuesController < ApplicationController

  def new
    @issue = Issue.new
  end

  def create
    @issue = Issue.new(issues_parameters)
    @issue.project_id = 1
    @issue.creator_id = 1
    @issue.company_id = 1
    if @issue.save
      flash[:alert] = 'Issue was successfully created.'
      redirect_to action: 'new'
    else
      flash[:alert] = 'Issue was not created.'
      redirect_to action: 'new'
    end

  end

  private
    def issues_parameters
      params.require(:issue).permit(:title, :description, :assignee_id, :status, :priority, :issue_type, documents: [])
    end
end