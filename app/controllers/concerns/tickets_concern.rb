module TicketsConcern
  def authorize_create!
    if !current_user.admin? && cannot?('create tickets'.to_sym, @project)
      flash[:alert]='You cannot create tickets on this project.'
      redirect_to @project
    end
  end

  def authorize_update!
    if !current_user.admin? && cannot?('edit tickets'.to_sym, @project)
      flash[:alert]='You cannot edit tickets on this project.'
      redirect_to @project
    end
  end
end