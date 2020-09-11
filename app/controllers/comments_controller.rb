class CommentsController < ApplicationController
  authorize_resource

  def create
    @resource = Issue.find(params[:issue_id])
    @comments = @resource.comments

    @comment = Comment.new(comment_params)
    @comment.commentable = @resource
    @comment.user = current_user
    @comment.company = current_user.company

    @comment = Comment.new if @comment.save
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      render 'show'
    else
      render 'edit'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_back fallback_location: root_url
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
