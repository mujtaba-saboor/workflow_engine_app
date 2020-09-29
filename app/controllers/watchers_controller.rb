# frozen_string_literal: true

class WatchersController < ApplicationController
  load_and_authorize_resource :issue
  load_and_authorize_resource through: :issue

  # GET /issues/:issue_id/watchers/administrate
  def administrate
    @pagy, @user_watchers = pagy(@issue.user_watchers)

    respond_to do |format|
      format.html
    end
  end

  # POST /issues/:issue_id/watchers
  def create
    if @watcher.save
      flash.now[:notice] = t('watchers.creation.success')

      # send email to the watching user
      @watcher.inform_started_watching
    else
      flash.now[:error] = t('watchers.creation.failure')
      @watcher = nil
    end

    respond_to do |format|
      format.js { render 'update' }
    end
  end

  # DELETE /issues/:issue_id/watchers/:id
  def destroy
    if @watcher.destroy
      flash.now[:notice] = t('watchers.deletion.success')
      @watcher.inform_stopped_watching
      @watcher = nil
    else
      flash.now[:error] = t('watchers.deletion.failure')
    end

    respond_to do |format|
      format.js { render 'update' }
    end
  end
end
