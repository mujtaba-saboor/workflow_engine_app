# frozen_string_literal: true

module CommentsHelper
  def resource_comments_display_path(resource)
    if resource.instance_of? Issue
      project_issue_path(resource.project, resource)
    elsif resource.instance_of? Project
      project_path(resource)
    else
      request.path
    end
  end

  def resource_comments_path(resource)
    public_send("#{resource.model_name.singular}_comments_path", resource)
  end

  def edit_resource_comment_path(resource, comment)
    public_send("edit_#{resource.model_name.singular}_comment_path", resource, comment)
  end

  def resource_comment_path(resource, comment)
    public_send("#{resource.model_name.singular}_comment_path", resource, comment)
  end
end
