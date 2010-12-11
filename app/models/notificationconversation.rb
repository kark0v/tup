class Notificationconversation < ActiveRecord::Base

	belongs_to :person
	belongs_to :notification

	after_create :create_notification

	##
	def create_notification
  	Notification.create(:from_id => self.person_id, :to_id => self.notification.to.id, :notification_id => self.notification_id)
	end

end

