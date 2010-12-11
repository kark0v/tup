class Review < ActiveRecord::Base

  ##Relationships

  belongs_to :website
  belongs_to :book
  belongs_to :person

  has_many :comments
	has_many :reports

  has_many :votes

  ## Named Scopes
  named_scope :website_reviews, :conditions => "website_id IS NOT NULL AND hidden <> true"
  named_scope :book_reviews, :conditions => "book_id IS NOT NULL AND hidden <> true"
  named_scope :books_recently_reviewed, lambda { |n| { :include => :book, :conditions => ['book_id IS NOT NULL AND reviews.hidden <> true AND books.hidden <> true'], :limit => n, :order => "reviews.created_at DESC" } }
	named_scope :active, lambda { |n| { :limit => n, :conditions => ['hidden <> true'] } }

  ## Callbacks
  after_create [:add_review_submission_points, :create_notification, :send_notification_email]

  ## Extra methods
  
  def reviewed_object
    self.book || self.website
  end
  
  def send_notification_email
    Mailer.deliver_review_notification(self) if self.reviewed_object.person.setting.notification_reviews
  end

  # create notification
  def create_notification
  	if self.website
  		# direct notification
			Notification.create(:from_id => self.person.id, :to_id => self.website.person.id, :review_id => self.id, :website_id => self.website.id)
			# network notification
			Notification.create(:from_id => self.person.id, :review_id => self.id, :website_id => self.website.id)
		else
			# direct notification
			Notification.create(:from_id => self.person.id, :to_id => self.book.person.id, :review_id => self.id, :book_id => self.book.id)
			# netwrok notification
			Notification.create(:from_id => self.person.id, :review_id => self.id, :book_id => self.book.id)
		end
  end

  ##Votes related functions
  def votes_for
    votes = self.votes.find_all_by_vote(true)
    votes.size
  end

  def votes_against
    votes = self.votes.find_all_by_vote(false)
    votes.size
  end

  def votes_result
    self.votes_for - self.votes_against
  end

  def voted_by_person?( person_id)
    rtn = false
    if person_id
      votes = self.votes.find_by_person_id(person_id)
      unless votes.nil?
        rtn = true
      end
    end
    rtn
  end

  def voted_positive? (person_id)
    rtn = false
    if person_id
      vote_true = self.votes.find_all_by_person_id_and_vote(person_id, true)
      unless vote_true.empty?
        rtn = true
      end
    end
    rtn
  end
	
  def voted_negative? (person_id)
    rtn = false
    if person_id
      vote_false = self.votes.find_all_by_person_id_and_vote(person_id, false)
      unless vote_false.empty?
        rtn = true
      end
    end
    rtn
  end
	
  def add_review_submission_points
		ep = EarnedPoint.new

		if self.website
	    ep.point = Point.find_by_reason('Review Website')
		else
	    ep.point = Point.find_by_reason('Review Book')
		end

    ep.person = self.person
    ep.rewardable = self
    ep.save

		self.person.total_points = self.person.total_points + ep.point.quantity
		self.person.save
  end
  
  def remove_review_submission_points
		ep = EarnedPoint.new

		if self.website
	    ep.point = Point.find_by_reason('Website Review Removed')
		else
	    ep.point = Point.find_by_reason('Book Review Removed')
		end

    ep.person = self.person
    ep.rewardable = self
    ep.save

		self.person.total_points = self.person.total_points + ep.point.quantity
		self.person.save
  end
end
