class ProjectsController < ApplicationController

  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # list projects
  def index
    @projects = Project.all
  end

  # renders project creation form
  def new
    @project = Project.new
  end

  # do create a project
  def create
    @project = Project.new project_params
    if @project.save
      #@note @rails combining redict and flash messages
      redirect_to @project, notice: "Project has been created."
    else
      flash[:alert] = "Project has not been created"
      render :new
    end
  end

  def show
    # rendered useless with set_project before_action
    # @project = Project.find params[:id]
  end

  def edit
    # rendered useless with set_project before_action
    # @project = Project.find params[:id]
  end

  def update
    # rendered useless with set_project before_action
    # @project = Project.find params[:id]
    if @project.update project_params
      flash[:notice] ='Project has been updated.'
      redirect_to @project
    else
      flash[:alert]="Project has not been updated."
      render :edit
    end
  end

  def destroy
    # rendered useless with set_project before_action
    # Project.find(params[:id])
    @project.destroy
    flash[:notice] = "Project has been destroyed."
    redirect_to projects_path
  end

  private

  def project_params
    params.require(:project).permit(:name, :description)
  end

  # find a project by id, if not exists redirect to index of projects
  def set_project
    @project = Project.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'The project you were looking for could not be found.'
    redirect_to projects_path
  end

end
