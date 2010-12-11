class Message < ActiveRecord::Base

  belongs_to :person
  belongs_to :conversation
	
	has_many :reports	

  after_create :send_notification

  def send_notification
    Mailer.send_later :deliver_message_notification, self
  end

end
