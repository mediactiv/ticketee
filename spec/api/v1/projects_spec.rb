require 'spec_helper'

describe '/api/v1/projects', type: :api do

  include Rack::Test::Methods


  let!(:user) { FactoryGirl.create(:user) }
  let!(:admin_user){FactoryGirl.create(:admin_user)}
  let!(:token) { user.authentication_token }
  let!(:project) { FactoryGirl.create(:project) }
  let!(:unauthorized_project) { FactoryGirl.create(:project, name: 'Unauthorized') }
  before do
    user.permissions.create!(action: 'view', thing: project)
    FactoryGirl.create(:project, name: 'Access Denied')
  end

  context 'creating a project' do
    let(:url) { api_v1_projects_path }

    it 'successful JSON' do

      post api_v1_projects_path(format: :json), token: admin_user.authentication_token, project: {name: 'Inspector'}

      expect(last_response.status).to eql(201)

      project = Project.find_by(name: 'Inspector')
      project_url = api_v1_project_path(project)
      expect(last_response.headers['location']).to eql(project_url)

      expect(last_response.body).to eql(project.to_json)
    end

    it 'unsuccessful JSON' do
      post api_v1_projects_url(format: :json), token: admin_user.authentication_token,
      :project => {name: ''}
      last_response.status.should eql(422)
      errors = {errors: {
        name: ["can't be blank"]
      }}.to_json
      last_response.body.should eql(errors)
    end
  end

  context 'updating a project' do
    before do
      user.admin = true
      user.save
    end
    let(:url){api_v1_project_url(project)}
    it '200' do
      put url,token:user.authentication_token,project:{
        name:'Updated name'
      }
      expect(last_response.status).to eql(204)
      expect(last_response.body).to eql('')
      project.reload
      expect(project.name).to eql('Updated name')
    end
  end

  context 'deleting a project' do
    before do
      user.admin = true
      user.save
    end
    it '204'do
      delete api_v1_project_url(project),token:user.authentication_token
      expect(last_response.status).to eql(204)
      expect(Project.exists?(project.id)).to eql(false)
    end
  end

  context 'one project viewable by this user ' do
    it '200' do
      get api_v1_project_url(project), token: token, format: :json
      expect(last_response.status).to eql(200)
    end
  end

  context 'one project not viewable by this user' do
    it '404' do
      get api_v1_project_url(unauthorized_project), token: token, format: :json
      expect(last_response.status).to eql(404)
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