class Api::V1::ProjectsController < Api::V1::BaseController

  before_action :authorize_admin, except: [:index, :show]

  def index
    respond_with Project.for(current_user).all
  end

  def show
    begin
      respond_with Project.for(current_user).find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      respond_with(404)
    end
  end


  def create
    project=Project.new(project_params)
    if project.save
      respond_with(project, location: api_v1_project_path(project))
    else
      respond_with(project)
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :description)
  end

end
