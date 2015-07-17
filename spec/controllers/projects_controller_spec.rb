require 'spec_helper'

#@note @rails unit testing controllers with rspec
describe ProjectsController do


  it 'displays an error for a missing project' do
    get :show, id: 'not-here'
    expect(response).to redirect_to(projects_path)
    expect(flash[:alert]).to eql('The project you were looking for could not be found.')
  end

  let(:user){FactoryGirl.create(:user)}

  context 'standard users' do
    before  do
      sign_in(user)
    end
    {:new=>:get,:create=>:post,:edit=>:get,:update=>:put,:destroy=>:delete}.each do |action,method|
      it "cannot access the #{action} action" do
        #explicitely send a request to a controller method
        send(method,action,:id=>FactoryGirl.create(:project))
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eql('You must be an admin to do that.')
      end
    end
  end
end
