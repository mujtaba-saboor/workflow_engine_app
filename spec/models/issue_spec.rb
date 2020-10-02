# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Issue, type: :model do
  context 'validation_tests' do
    before(:each) do
      @company = Company.create(name: 'Some Company', subdomain: 'somecompany')
      @creator = User.create(name: 'A User', email: 'someemail@email.com', password: 'hello123', company: @company, role: 'OWNER')
      @assignee = User.create(name: 'A User', email: 'anotheremail@email.com', password: 'hello123', company: @company, role: 'OWNER')
      @project = Project.create(name: 'A project', project_category: 'TEAM', company: @company)
    end

    it 'ensures presence of title' do
      issue = Issue.new(description: 'This is description', status: 'open', priority: 'low', issue_type: 'bug', company: @company, creator: @creator, assignee: @assignee, project: @project).save
      expect(issue).to eq(false)
    end

    it 'ensures presence of priority' do
      issue = Issue.new(title: 'A title', description: 'This is description', status: 'open', issue_type: 'bug', company: @company, creator: @creator, assignee: @assignee, project: @project).save
      expect(issue).to eq(false)
    end

    it 'ensures priority is either "low" or "high"' do
      valid_priorities = Issue.priorities.keys
      invalid_priorities = %w[invalid another_invalid]

      valid_priorities.each do |priority|
        issue = Issue.new(title: 'A title', description: 'This is description', status: 'open', priority: priority, issue_type: 'bug', company: @company, creator: @creator, assignee: @assignee, project: @project).save
        expect(issue).to eq(true)
      end
      invalid_priorities.each do |priority|
        issue = Issue.new(title: 'A title', description: 'This is description', status: 'open', priority: priority, issue_type: 'bug', company: @company, creator: @creator, assignee: @assignee, project: @project)
        binding.pry
        expect{ issue.save }.to raise_exception
      end
    end

    it 'ensures presence of issue_type' do
      issue = Issue.new(description: 'This is description', status: 'open', priority: 'low', company: @company, creator: @creator, assignee: @assignee, project: @project).save
      expect(issue).to eq(false)
    end

    it 'ensures issue_type to be "bug" or "issue"' do
      vailid_issue_type = Issue.issue_types.keys
      invalid_issue_types = ['', 'hello']

      vailid_issue_type.each do |issue_type|
        issue = Issue.new(title: 'A title', description: 'This is description', status: 'open', priority: 'high', issue_type: issue_type, company: @company, creator: @creator, assignee: @assignee, project: @project).save
        binding.pry
        expect(issue).to eq(true)
      end
      invalid_issue_types.each do |issue_type|
        issue = Issue.new(title: 'A title', description: 'This is description', status: 'open', priority: 'high', issue_type: issue_type, company: @company, creator: @creator, assignee: @assignee, project: @project).save
        expect(issue).to eq(false)
      end
    end

    it 'ensures status to be "open", "in_progress", "resolved" or "closed"' do
      valid_statuses = Issue.statuses.keys
      invalid_statuses = ['', 'world']

      valid_statuses.each do |status|
        issue = Issue.new(title: 'A title', description: 'This is description', status: status, priority: 'high', issue_type: 'issue', company: @company, creator: @creator, assignee: @assignee, project: @project).save
        expect(issue).to eq(true)
      end
      invalid_statuses.each do |status|
        issue = Issue.new(title: 'A title', description: 'This is description', status: status, priority: 'high', issue_type: 'issue', company: @company, creator: @creator, assignee: @assignee, project: @project).save
        expect(issue).to eq(false)
      end
    end
  end
end
