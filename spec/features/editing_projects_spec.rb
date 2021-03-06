require 'spec_helper'

feature 'editing projects' do

  before do
    @project = FactoryGirl.create :project, name: 'TextMate 2'
    @admin_user = FactoryGirl.create :admin_user
    sign_in_as!(@admin_user)
    visit '/'
    click_link @project.name
    click_link 'Edit Project'
  end

  scenario 'Updating a project' do
    fill_in 'Name', with: 'TextMate 2  beta'
    click_button 'Update Project'

    expect(page).to have_content('Project has been updated')
  end

  scenario "Updating a project with invalid attributes is bad" do
    fill_in "Name",with:""
    click_button "Update Project"

    expect(page).to have_content("Project has not been updated")
  end

end