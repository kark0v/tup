class Favorite < ActiveRecord::Base

  ## Relationships
  belongs_to :person
	belongs_to :website
	belongs_to :job
  belongs_to :book

  ## Callbacks

  after_create :create_notification

  ## Extra Methods

  # create notification
  def create_notification
  	if self.website
			Notification.create(:from_id => self.person.id, :to_id => self.website.person.id, :favorite_id => self.id, :website_id => self.website.id)
			Notification.create(:from_id => self.person.id, :favorite_id => self.id, :website_id => self.website.id)
  	elsif self.book
			Notification.create(:from_id => self.person.id, :to_id => self.book.person.id, :favorite_id => self.id, :book_id => self.book.id)
			Notification.create(:from_id => self.person.id, :favorite_id => self.id, :book_id => self.book.id)
		elsif self.job
			Notification.create(:from_id => self.person.id, :to_id => self.job.person.id, :favorite_id => self.id, :job_id => self.job.id)
			Notification.create(:from_id => self.person.id, :favorite_id => self.id, :job_id => self.job.id)
  	end
  end

end

