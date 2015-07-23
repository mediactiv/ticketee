class Api::V1::TicketsController < Api::V1::BaseController

  before_action :find_project
  before_action :find_ticket, only:[:show,:update,:delete]

  def index
    respond_with @project.tickets
  end

  def show
    respond_with @ticket
  end

  private

  def find_project
    @project = Project.for(current_user).find(params[:project_id])
  rescue ActiveRecord::RecordNotFound => e
    respond_with({error:'The project you were looking for could not be found.',status:404})
  end

  def find_ticket
    @ticket = @project.tickets.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    respond_with({error:'The ticket you were looking for could not be found.',status:404})
  end
end
