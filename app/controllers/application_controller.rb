class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :require_signin!
  helper_method :current_user
  helper_method :authorize_admin!

  private
  def require_signin!
    if current_user.nil?
      flash[:error] = 'You need to sign in or sign up before continuing.'
      redirect_to signin_url
    end
  end


  def current_user
    @current_user||=User.find(session[:user_id]) if session[:user_id]
  end

  def authorize_admin!
    require_signin!
    unless current_user.admin?
      flash[:alert] = 'You must be an admin to do that.'
      redirect_to root_path
    end
  end

  def authorize_create!
    if !current_user.admin? && cannot?('create tickets'.to_sym, @project)
      flash[:alert]='You cannot create tickets on this project.'
      redirect_to @project
    end
  end

end