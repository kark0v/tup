class Vote < ActiveRecord::Base
  
  belongs_to :person
  belongs_to :review
  
  validates_uniqueness_of :person_id, :scope => [ :review_id ]
 
  ## Callbacks
  after_create [:add_vote_submission_points, :send_notification_email]
  
  def send_notification_email
    Mailer.deliver_vote_notification(self) if self.review.person.setting.notification_comment
  end
	
  def add_vote_submission_points
    ## Points for Voter
		ep = EarnedPoint.new
    ep.point = Point.find_by_reason('Vote Review')
    ep.person = self.person
    ep.rewardable = self.review
    ep.save
		
		self.person.total_points = self.person.total_points + ep.point.quantity
		self.person.save
		
    ## Points for Reviewer
		ep = EarnedPoint.new
		if self.vote
    	ep.point = Point.find_by_reason('Review Voted Up')
		else
			ep.point = Point.find_by_reason('Review Voted Down')
		end
    ep.person = self.review.person
    ep.rewardable = self.review
    ep.save
		
		self.review.person.total_points = self.review.person.total_points + ep.point.quantity
		self.review.person.save
  end
	
  def update_vote_author_points	
		ep = EarnedPoint.new
		if self.vote
    	ep.point = Point.find_by_reason('Review Voted Down to Up')
		else
			ep.point = Point.find_by_reason('Review Voted Up to Down')
		end
    ep.person = self.review.person
    ep.rewardable = self.review
    ep.save
		
		self.review.person.total_points = self.review.person.total_points + ep.point.quantity
		self.review.person.save
  end
	  
end
