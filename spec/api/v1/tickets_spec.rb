require 'spec_helper'



describe '/api/v1/project/id?/tickets' do


include Rack::Test::Methods

  before :each do
    @user= FactoryGirl.create(:user)
    @admin_user=FactoryGirl.create(:admin_user)
    @project=FactoryGirl.create(:project)
    @user.permissions.create!(action:'view',thing:@project)
  end
  it 'Project should exist' do
    expect(Project.exists?(@project.id)).to eql(true)
  end

  describe 'index' do

    before do
      5.times do
        FactoryGirl.create(:ticket,project:@project,user:@user)
      end
    end

    it 'should 200' do
      get api_v1_project_tickets_url(@project),token: @user.authentication_token
      
      expect(last_response.status).to eql(200)
    end


  end
end