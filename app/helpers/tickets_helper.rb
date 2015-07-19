module TicketsHelper
  #@note @rails writing a view helper
  # display comment state transition
  def state_for(comment)
    content_tag(:div, class: 'states') do
    if comment.state
      previous_state = comment.previous_state
      if previous_state && comment.state !=previous_state
        "#{render previous_state} &rarr; #{render comment.state}"
      else
        render comment.state
      end
    end
    end
  end
end
