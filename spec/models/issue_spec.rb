# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Issue, type: :model do
  context 'validation_tests' do
    before(:each) do
      @company = create(:company)
      @creator = create(:user, company: @company)
      @assignee = create(:user, company: @company)
      @project = create(:project, company: @company)
    end

    it 'ensures presence of title' do
      issue = build(:issue, company: @company, creator: @creator, assignee: @assignee, project: @project)
      issue.title = nil
      expect(issue.save).to eq(false)
    end

    it 'ensures presence of priority' do
      issue = build(:issue, company: @company, creator: @creator, assignee: @assignee, project: @project)
      issue.priority = nil
      expect(issue.save).to eq(false)
    end

    it 'ensures priority is either "low" or "high"' do
      valid_priorities = Issue.priorities.keys
      invalid_priorities = %w[invalid another_invalid]

      valid_priorities.each do |priority|
        expect(build(:issue, company: @company, creator: @creator, assignee: @assignee, project: @project, priority: priority).save).to eq(true)
      end
      invalid_priorities.each do |priority|
        expect { build(:issue, company: @company, creator: @creator, assignee: @assignee, project: @project, priority: priority) }.to raise_error(ArgumentError)
      end
    end

    it 'ensures presence of issue_type' do
      issue = build(:issue, company: @company, creator: @creator, assignee: @assignee, project: @project)
      issue.issue_type = nil
      expect(issue.save).to eq(false)
    end

    it 'ensures issue_type to be "bug" or "issue"' do
      vailid_issue_type = Issue.issue_types.keys
      invalid_issue_types = ['hello']

      vailid_issue_type.each do |issue_type|
        expect(build(:issue, company: @company, creator: @creator, assignee: @assignee, project: @project, issue_type: issue_type).save).to eq(true)
      end
      invalid_issue_types.each do |issue_type|
        expect { build(:issue, company: @company, creator: @creator, assignee: @assignee, project: @project, issue_type: issue_type) }.to raise_error(ArgumentError)
      end
    end

    it 'ensures status to be "open", "in_progress", "resolved" or "closed"' do
      valid_statuses = Issue.statuses.keys
      invalid_statuses = ['world']

      valid_statuses.each do |status|
        expect(build(:issue, company: @company, creator: @creator, assignee: @assignee, project: @project, status: status).save).to eq(true)
      end
      invalid_statuses.each do |status|
        expect { build(:issue, company: @company, creator: @creator, assignee: @assignee, project: @project, status: status) }.to raise_error(ArgumentError)
      end
    end
  end
end
