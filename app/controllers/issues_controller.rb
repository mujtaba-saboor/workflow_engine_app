# frozen_string_literal: true

class IssuesController < ApplicationController
  WITHOUT_THROUGH = %i[all filter].freeze

  load_and_authorize_resource :project, find_by: :sequence_num, through: :current_company, except: WITHOUT_THROUGH
  load_and_authorize_resource through: :project, except: WITHOUT_THROUGH
  load_and_authorize_resource only: WITHOUT_THROUGH

  add_breadcrumb I18n.t('shared.home'), :root_path, only: %i[show new edit all]
  add_breadcrumb I18n.t('shared.projects'), :projects_path, only: %i[show new edit]

  before_action :load_valid_assignees, only: %i[new edit update create]
  before_action :load_issue_watcher, only: %i[show update_status]

  # GET /issues
  def all
    add_breadcrumb t('shared.issues'), :issues_path
    load_pagy
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /projects/:project_id/issues/:id
  def show
    @comment = Comment.new
    @user_watchers = @issue.user_watchers
    @pagy, @comments = pagy(Comment.where(commentable: @issue))
    add_breadcrumb @issue.project.name, project_path(@issue.project.sequence_num)
    add_breadcrumb @issue.title, :project_issue_path
    respond_to do |format|
      format.html
    end
  end

  # GET /projects/:project_id/issues/new
  def new
    add_breadcrumb @issue.project.name, project_path(@issue.project.sequence_num)
    add_breadcrumb t('shared.new_resource', resource_name: t('shared.issue')), :new_project_issue_path
    respond_to do |format|
      format.html
    end
  end

  # POST /projects/:project_id/issues
  def create
    # Here the company is being set via the cancancan ability written as,
    # can :create, Issue, company_id: user.company_id

    # Similar is the case for user
    # can :create, Issue, creator_id: user.id

    # Project for the issue is also set automatically here via the cancancan load_and_authorize statements
    # as given above

    respond_to do |format|
      if @issue.save
        flash[:notice] = t('shared.creation_successful', resource: Issue.model_name.human)
        format.html { redirect_to project_issue_path(@project, @issue) }
      else
        flash[:error] = t('shared.creation_unsuccessful', resource: Issue.model_name.human.downcase)
        format.html { render 'new' }
      end
    end
  end

  # GET /projects/:project_id/issues/:id/edit
  def edit
    add_breadcrumb @issue.project.name, project_path(@issue.project.id)
    add_breadcrumb @issue.title, :project_issue_path
    add_breadcrumb t('shared.edit'), :edit_project_issue_path
    respond_to do |format|
      format.html
    end
  end

  # PATCH /projects/:project_id/issues/:id(.:format)
  # PUT /projects/:project_id/issues/:id(.:format)
  def update
    respond_to do |format|
      if @issue.update(issue_params)
        flash[:notice] = t('shared.updation_successful', resource: Issue.model_name.human)
        format.html { redirect_to project_issue_path(@project, @issue) }
      else
        flash[:error] = t('shared.updation_unsuccessful', resource: Issue.model_name.human.downcase)
        format.html { render 'edit' }
      end
    end
  end

  # DELETE /projects/:project_id/issues/:id
  def destroy
    if @issue.destroy
      flash[:notice] = t('shared.deletion_successful', resource: Issue.model_name.human)
    else
      flash[:error] = t('shared.deletion_unsuccessful', resource: Issue.model_name.human.downcase)
    end
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
    end
  end

  # PATCH /projects/:project_id/issues/:id/update_status
  def update_status
    event_str = params[:status]

    if Issue::AASM_EVENTS_HUMANIZED.include?(event_str) && (update_event = @issue.aasm.events(permitted: true).find { |event| event.name.to_s.humanize == event_str })
      @issue.public_send("#{update_event.name}!")

      flash.now[:notice] = t('issues.update_status.success', new_status: Issue.human_enum_name(:status, @issue.status))
    else
      flash.now[:error] = t('issues.update_status.failure')
    end

    respond_to do |format|
      format.js
    end
  end

  # GET /issues/filter
  def filter
    search_options = {
      id: @issues.pluck(:id),
      page: params[:page],
      per_page: Issue::PAGE_SIZE
    }

    search_options[:issue_type] = params[:issue_type] if params[:issue_type].present?
    search_options[:status] = params[:status] if params[:status].present?
    search_options[:priority] = params[:priority] if params[:priority].present?

    @pagy, @issues = Issue.filter_search(params[:issue_title], search_options)

    respond_to do |format|
      format.js { render 'all' }
    end
  end

  def add_document_attachment
    @issue.documents.attach(add_documents_params[:documents])
    redirect_back(fallback_location: project_issue_path)
  end

  def delete_document_attachment
    @document = ActiveStorage::Attachment.find(params[:format])
    @document.purge
    redirect_back(fallback_location: project_issue_path)
  end

  private

  def load_valid_assignees
    @valid_assignees = @project.valid_assignees
  end

  def load_issue_watcher
    @watcher = current_user.watcher_for(@issue)
  end

  def load_pagy
    @pagy, @issues = pagy(@issues, link_extra: "data-remote='true'", items: Issue::PAGE_SIZE)
    @issues.includes(:project)
  end

  def issue_params
    params.require(:issue).permit(:title, :description, :issue_type, :priority, :status, :assignee_id, documents: [])
  end

  def add_documents_params
    params.require(:issue).permit(documents: [])
  end
end
