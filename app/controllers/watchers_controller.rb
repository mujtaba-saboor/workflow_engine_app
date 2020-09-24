# frozen_string_literal: true

class WatchersController < ApplicationController
  load_and_authorize_resource :issue
  load_and_authorize_resource through: :issue

  # POST /issues/:issue_id/watchers
  def create
    if @watcher.save
      flash[:notice] = t('watchers.creation.success')

      # send email to the watching user
    else
      flash[:error] = t('watchers.creation.failure')
      @watcher = nil
    end

    respond_to do |format|
      format.js { render 'update' }
    end
  end

  # DELETE /issues/:issue_id/watchers/:id
  def destroy
    if @watcher.destroy
      flash[:notice] = t('watchers.deletion.success')
      @watcher = nil
    else
      flash[:error] = t('watchers.deletion.failure')
    end

    respond_to do |format|
      format.js { render 'update' }
    end
  end
end
