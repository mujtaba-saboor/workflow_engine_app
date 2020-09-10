class IssuesController < ApplicationController
  def show
    @issue = Issue.find_by!(id: params[:id], project_id: params[:project_id])
    @comment = Comment.new
    @comments = Comment.where(commentable: @issue)
  end

  # private

  # def issue_params
  #   params.require(:issue).permit(:title, :description, :issue_type, :priority, :status, :project_id, :creator_id, :assignee_id, :company_id)
  # end
end
