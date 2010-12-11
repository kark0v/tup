class Comment < ActiveRecord::Base

  ## Relationships
  belongs_to :review
  belongs_to :person

	has_many :reports

  ## Named scopes
  named_scope :recently_submited, lambda { |n| { :limit => n, :conditions => ['hidden <> true'], :order => "created_at DESC" } }
	named_scope :active, lambda { |n| { :limit => n, :conditions => ['hidden <> true'] } }

  ## Callbacks
  after_create [:add_comment_submission_points, :create_notification, :send_notification_email]

  ## Extra methods

  # create notifications
  def create_notification
  	Notification.create(:from_id => self.person.id, :to_id => self.review.person.id, :comment_id => self.id, :review_id => self.review.id)
  	Notification.create(:from_id => self.person.id, :comment_id => self.id, :review_id => self.review.id)
  end
  
  def send_notification_email
    Mailer.deliver_comment_notification(self) if self.review.person.setting.notification_comment
  end

  def add_comment_submission_points
		ep = EarnedPoint.new

		if self.review.website
	    ep.point = Point.find_by_reason('Comment Review Website')
		else
	    ep.point = Point.find_by_reason('Comment Review Book')
		end

    ep.person = self.person
    ep.rewardable = self
    ep.save

		self.person.total_points = self.person.total_points + ep.point.quantity
		self.person.save
  end
  
  def remove_comment_submission_points
		ep = EarnedPoint.new

		if self.review.website
	    ep.point = Point.find_by_reason('Website Comment Review Removed')
		else
	    ep.point = Point.find_by_reason('Book Website Comment Review Removed')
		end

    ep.person = self.person
    ep.rewardable = self
    ep.save

		self.person.total_points = self.person.total_points + ep.point.quantity
		self.person.save    
  end
end
