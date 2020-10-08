require 'rails_helper'

RSpec.describe Team, type: :model do
  context 'validations' do
    before(:each) do
      @company = Company.create(FactoryGirl.attributes_for(:company))
      team_params = FactoryGirl.attributes_for(:team)
      team_params[:company_id] = @company.id
      @team = Team.create(team_params)
    end

    it 'should return true when validations pass' do
      expect(@team.valid?).to eq true
    end

    it 'should return false when validations fail' do
      @team.company = nil
      expect(@team.valid?).to eq false
    end

    it 'should return false when name is nil' do
      @team.name = nil
      expect(@team.valid?).to eq false
    end
  end
end
