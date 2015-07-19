class CommentsController < ApplicationController
  before_filter :require_signin!
  before_filter :set_ticket

  def create
    @comment = @ticket.comments.build(comment_params)
    @states = State.all
    @comment.user= current_user
    if @comment.save
      flash[:notice] = 'Comment has been created.'
      redirect_to [@ticket.project, @ticket]
    else
      flash[:alert] = 'Comment has not been created.'
      render :template => 'tickets/show'
    end
  end

  def comment_params
    params.require(:comment).permit(:text,:state_id)
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:ticket_id])
  end


end
