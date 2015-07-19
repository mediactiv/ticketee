class Comment < ActiveRecord::Base

  after_create :set_ticket_state
  before_create :set_previous_state

  delegate :project, to: :ticket

  belongs_to :ticket
  belongs_to :user
  belongs_to :state
  belongs_to :previous_state, class_name: 'State'

  validates :text, presence: true

  private

  # set ticket state when comment is created
  def set_ticket_state
    self.ticket.state = self.state
    self.ticket.save!
  end

  # set previous state before comment is created
  def set_previous_state
    self.previous_state = ticket.state
  end

end
