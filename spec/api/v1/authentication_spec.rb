require 'spec_helper'

describe 'API errors', type: :api do

  include Rack::Test::Methods

  it 'making a request with no token' do
    get '/api/v1/projects.json', token: ''
    error = {error: 'Token is invalid.'}
    expect(last_response.body).to eql(error.to_json)
  end

end