class Api::V1::BaseController < ActionController::Base
  respond_to :json, :xml

  before_action :authenticate_user

  attr_accessor :current_user

  private
  
  def authenticate_user
    @current_user = User.find_by(authentication_token: params[:token])
    unless @current_user
      respond_with({error: 'Token is invalid.'})
    end
  end

  def authorize_admin
    unless @current_user.admin?
      respond_with({error:'Unauthorized'},status: 401,location: location)
    end
  end
end