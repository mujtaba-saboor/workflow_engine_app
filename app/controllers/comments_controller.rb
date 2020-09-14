class CommentsController < ApplicationController
  load_and_authorize_resource except: %i[create]

  def create
    @resource = Issue.find(params[:issue_id])
    authorize! :read, @resource

    @comment = Comment.new(comment_params)
    authorize! :create, @comment

    @comment.commentable = @resource
    @comment.user = current_user
    @comment.company = current_user.company

    @comment = Comment.new if @comment.save
    @pagy, @comments = pagy(@resource.comments)
    # TODO: Add a proper decorator class for this type of thing
    @pagy.instance_variable_set(:@custom_link, project_issue_path(@resource.project, @resource))
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      render 'show'
    else
      render 'edit'
    end
  end

  def destroy
    @comment.destroy
    redirect_back fallback_location: root_url
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
