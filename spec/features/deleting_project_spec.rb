require 'spec_helper'

feature 'Deleting projects' do
  scenario 'Deleting a project' do
    @project = FactoryGirl.create(:project,name:'TextMate 2')
    @admin_user = FactoryGirl.create(:admin_user)
    sign_in_as!(@admin_user)
    visit '/'
    click_link @project.name
    click_link 'Delete Project'

    expect(page).to have_content('Project has been destroyed.')

    visit '/'

    expect(page).to have_no_content(@project.name)
  end
end