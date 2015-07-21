require 'spec_helper'

describe '/api/v1/projects', type: :api do

  include Rack::Test::Methods


  let!(:user) { FactoryGirl.create(:user) }
  let!(:token) { user.authentication_token }
  let!(:project) { FactoryGirl.create(:project) }

  before do
    user.permissions.create!(action: 'view', thing: project)
    FactoryGirl.create(:project, name: 'Access Denied')
  end

  context 'creating a project' do
    let(:url) { api_v1_projects_url }

    it 'successful JSON' do
      post "#{url}.json", token: token, project: {
                            name: 'Inspector'
                        }
      project = Project.find_by(name: 'Inspector')
      project_url = api_v1_project_path(project)
      expect(last_response.status).to eql(201)
      expect(last_response.headers['location']).to eql(project_url)
      expect(last_response.body).to eql(project.to_json)
    end

    it "unsuccessful JSON" do
      post "#{url}.json", :token => token,
           :project => {name:''}
      last_response.status.should eql(422)
      errors = {errors: {
          name: ["can't be blank"]
      }}.to_json
      last_response.body.should eql(errors)
    end
  end

  context 'projects viewable by this user' do
    let(:url) { api_v1_projects_url }
    it 'json' do
      get "#{url}.json", token: token
      projects_json = Project.for(user).all.to_json
      expect(last_response.body).to eql(projects_json)
      expect(last_response.status).to eql(200)
      projects = JSON.parse(last_response.body)
      expect(projects.any? do |p|
               p['name']===project.name
             end).to eql(true)
      expect(projects.any? do |p|
               p['name'] == 'Access Denied'
             end).to eql(false)
    end

    it 'XML' do
      get "#{url}.xml", token: token
      expect(last_response.body).to eql(Project.for(user).to_xml)
      projects = Nokogiri::XML(last_response.body)
      expect(projects.css('project name').text).to eql(project.name)
    end
  end
end