class CommentsController < ApplicationController
  load_and_authorize_resource :issue
  load_and_authorize_resource :project
  load_and_authorize_resource through: %i[issue project]
  before_action :set_up_pagy_and_resource, only: %i[create destroy]

  # POST /resources/:resource_id/comments
  def create
    if @comment.save
      flash.now[:notice] = t('comments.successful_creation_message')
      @comment = Comment.new
    else
      flash.now[:error] = t('comments.unsuccessful_creation_message')
    end

    respond_to do |format|
      format.js
    end
  end

  # GET /resources/:resource_id/comments/:id/edit
  def edit
    respond_to do |format|
      format.js
    end
  end

  # PUT    resources/:resource_id/comments/:id
  # PATCH  resources/:resource_id/comments/:id
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.js { render 'show' }
      else
        format.js { render 'edit' }
      end
    end
  end

  # DELETE resources/:resource_id/comments/:id
  def destroy
    if @comment.destroy
      flash.now[:notice] = t('comments.successful_deletion_message')
      @comment = Comment.new
    else
      flash.now[:error] = t('comments.unsuccessful_deletion_message')
    end

    respond_to do |format|
      format.html { redirect_back fallback_location: root_url }
      format.js
    end
  end

  private

  def set_up_pagy_and_resource
    @resource = @comment.commentable
    @pagy, @comments = pagy(@resource.comments)
    # TODO: Add a proper decorator class for this type of thing
    @pagy.instance_variable_set(:@custom_link, helpers.resource_comments_display_path(@resource))
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
