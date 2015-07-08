require 'spec_helper'

#@note @rails unit testing controllers with rspec
describe ProjectsController do
  it 'displays an error for a missing project' do
    get :show, id: 'not-here'
    expect(response).to redirect_to(projects_path)
    expect(flash[:alert]).to eql('The project you were looking for could not be found.')
  end
end
