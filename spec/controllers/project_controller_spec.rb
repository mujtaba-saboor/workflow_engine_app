require 'rails_helper'
RSpec.describe ProjectsController, type: :controller do
  describe 'For Project' do
    before(:each) do
      @company = Company.create(FactoryGirl.attributes_for(:company))
      user_params = FactoryGirl.attributes_for(:user)
      user_params[:company_id] = @company.id
      @user = User.create(user_params)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @request.host = "#{@company.subdomain}.lvh.me:3000"
      @user.confirm
      sign_in @user
      project_params = FactoryGirl.attributes_for(:project)
      project_params[:company] = @company
      @project = Project.create(project_params)
      team_params = FactoryGirl.attributes_for(:team)
      team_params[:company] = @company
      @team = Team.create(team_params)
    end

    describe 'GET index' do
      it 'returns a successful response' do
        get :index
        expect(response).to be_successful
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template('index')
      end
    end

    describe 'POST create' do
      context 'with valid attributes' do
        it 'creates a new project' do
          post :create, params: { project: FactoryGirl.attributes_for(:project), format: :js }
          expect(response.location).to eql project_url(@company.projects.last)
          expect(response.status).to eq 302
        end

        it 'increase the project list count by 1' do
          expect {
            post :create, params: { project: FactoryGirl.attributes_for(:project), format: :js }
          }.to change(@company.projects, :count).by(1)
        end
      end
      context 'with wrong attributes' do
        it 'it should not increate the project list count by 1' do
          project_params = FactoryGirl.attributes_for(:project)
          project_params[:project_category] = nil
          expect {
            post :create, params: { project: project_params, format: :js }
          }.to_not change(@company.projects, :count)
        end
      end
    end

    describe 'PATCH update' do
      context 'with valid attributes' do
        it 'update a project' do
          post :update, params: { id: @project.sequence_num, project: FactoryGirl.attributes_for(:project), format: :js }
          expect(response.location).to eql project_url(@project)
        end
      end

      context 'with invalid attributes' do
        it 'should not update project attributes' do
          project_params = FactoryGirl.attributes_for(:project)
          project_name = @project.name
          project_params[:name] = nil
          post :update, params: { id: @project.sequence_num, project: project_params, format: :js }
          expect(@project.name).to eql project_name
        end
      end
    end

    describe 'GET show' do
      it 'renders the :show view' do
        get :show, params: { id: @project.sequence_num }
        expect(response).to render_template :show
      end
    end

    describe 'DELETE destroy' do
      context 'valid deletion' do
        it 'should return http success' do
          expect {
            delete :destroy, params: { id: @project.sequence_num }
          }.to change(@company.projects, :count).by(-1)
        end

        it 'redirects to projects index page' do
          delete :destroy, params: { id: @project.sequence_num }
          expect(response).to redirect_to projects_path
        end
      end

      context 'invalid deletion' do
        it 'should not decrease the project list count by 1' do
          expect {
            delete :destroy, params: { id: 102 }
          }.to_not change(@company.projects, :count)
        end
      end
    end

    describe 'PATCH add_team_to_project' do
      context 'addition in project teams' do
        it "should add a team in project's team list" do
          patch :add_team_to_project, params: { id: @project.sequence_num, project: { team: @team.id }, format: :js }
          expect(@project.teams.count).to eql 1
        end
      end
    end
  end
end
