class CommentsController < ApplicationController
  load_and_authorize_resource

  # issue_comments POST /issues/:issue_id/comments(.:format) comments#create
  def create
    @resource = Issue.find(params[:issue_id])
    authorize! :read, @resource

    @comment.commentable = @resource
    @comment = Comment.new if @comment.save
    @pagy, @comments = pagy(@resource.comments)
    # TODO: Add a proper decorator class for this type of thing
    @pagy.instance_variable_set(:@custom_link, project_issue_path(@resource.project, @resource))
    respond_to :js
  end

  # edit_comment GET /comments/:id/edit(.:format) comments#edit
  def edit
    respond_to :js
  end

  # comment PATCH  /comments/:id(.:format) comments#update
  # comment PUT    /comments/:id(.:format) comments#update
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.js { render 'show' }
      else
        format.js { render 'edit' }
      end
    end
  end

  # comment DELETE /comments/:id(.:format) comments#destroy
  def destroy
    respond_to do |format|
      if @comment.destroy
        flash[:comment_deletion_success] = t('comments.successful_deletion_message')
      else
        flash[:comment_deletion_warning] = t('comments.unsuccessful_deletion_message')
      end

      format.html { redirect_back fallback_location: root_url }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
