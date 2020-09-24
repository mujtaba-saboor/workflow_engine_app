# frozen_string_literal: true

class WatchersController < ApplicationController
  load_and_authorize_resource :issue
  load_and_authorize_resource through: :issue

  # POST /issues/:issue_id/watchers
  def create
    p @watcher
    if @watcher.save
      flash[:notice] = t('watchers.creation.success')
      @watching_issue = true
    else
      flash[:error] = t('watchers.creation.failure')
      @watching_issue = false
    end

    respond_to do |format|
      format.js { render 'update' }
    end
  end

  # DELETE /issues/:issue_id/watchers/
  def destroy
    @watcher = Watcher.find_by(user_id: current_user.id, issue_id: @issue.id)
    if @watcher.destroy
      flash[:notice] = t('watchers.deletion.success')
      @watching_issue = false
    else
      flash[:error] = t('watchers.deletion.failure')
      @watching_issue = true
    end

    respond_to do |format|
      format.js { render 'update' }
    end
  end
end
