class CommentsController < ApplicationController
  def create
    @resource = Issue.find(params[:issue_id]) if params[:issue_id]
    @comments = @resource.comments

    @comment = Comment.new(comment_params)
    @comment.commentable = @resource
    @comment.user = current_user
    @comment.company = current_user.company

    @comment = Comment.new if @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
