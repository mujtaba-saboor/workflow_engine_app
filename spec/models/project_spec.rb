require 'rails_helper'

RSpec.describe Project, type: :model do
  context 'validations' do
    before(:each) do
      @company = Company.create(FactoryGirl.attributes_for(:company))
      project_params = FactoryGirl.attributes_for(:project)
      project_params[:company_id] = @company.id
      @project = Project.create(project_params)
    end

    it 'should return true when all validations pass' do
      expect(@project.valid?).to eq true
    end

    it 'should return false when validations fail' do
      @project.company = nil
      expect(@project.valid?).to eq false
    end

    it 'should return false when name is nil' do
      @project.name = nil
      expect(@project.valid?).to eq false
    end

    it 'should return false when category is not valid one' do
      @project.project_category = 'Group'
      expect(@project.valid?).to eq false
    end

    it 'should return false when category is not provided' do
      @project.project_category = nil
      expect(@project.valid?).to eq false
    end

    it 'should return true if the project_category is TEAM' do
      @project.project_category = 'TEAM'
      expect(@project.team_project?).to be true
    end

    it 'should return false if the project_category is not TEAM' do
      @project.project_category = 'INDEPENDENT'
      expect(@project.team_project?).to be false
    end
  end
end
