require 'spec_helper'

describe 'rate limiting',type: :api do

  before do
    @user = FactoryGirl.create(:user)
  end

  it 'counts user\'s requests' do
    expect(@user.request_count).to eql(0)
    get api_v1_projects_url,token: @user.authentication_token
    @user.reload
    expect(@user.request_count).to eql(1)
  end

end