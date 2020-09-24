# frozen_string_literal: true

class WatchersController < ApplicationController
  load_and_authorize_resource :issue
  load_and_authorize_resource through: :issue

  # POST /issues/:issue_id/watchers
  def create
    if @watcher.save
      flash.now[:notice] = t('watchers.creation.success')

      # send email to the watching user
      WatcherMailer.watching_issue_now(current_user, @issue, @current_company.subdomain).deliver
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
      WatcherMailer.stopped_watching_issue(current_user, @issue, @current_company.subdomain).deliver
      @watcher = nil
    else
      flash.now[:error] = t('watchers.deletion.failure')
    end

    respond_to do |format|
      format.js { render 'update' }
    end
  end
end
