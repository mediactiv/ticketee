class Admin::BaseController < ApplicationController

  before_action :authorize_admin!

  def index
    @users = User.order(:email)
  end

end