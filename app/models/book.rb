class Book < ActiveRecord::Base

  acts_as_taggable_on :tags

  acts_as_rateable

  ## Relationships
  belongs_to :person
  has_many :suggestions
	has_many :reports
	has_many :reviews
	has_many :favorites
	has_many :listbookss

  has_attached_file :photo,
    :default_url => "/images/cover.jpg",
    :styles => {
      :full => '285x376>',
      :thumb => "100x150#",
      :small => "50x75#"
    }
	validates_attachment_size :photo, :less_than => 2.megabytes	
	validates_attachment_content_type :photo,
		:content_type => [
			'image/jpeg',
			'image/pjpeg', # for progressive jpeg (IE mine-type for regular jpeg) 
			'image/png',
			'image/x-png', # IE mine-type for PNG
			'image/gif'
	]

  ## Named scopes
  named_scope :recently_submited, lambda { |n| { :limit => n, :conditions => ['hidden <> true AND pending <> true'], :order => "created_at DESC" } }
  named_scope :featured, lambda { |n| { :limit => n, :conditions => ['hidden <> true AND featured = true'] } }
  named_scope :active, lambda { |n| { :limit => n, :conditions => ['hidden <> true AND pending <> 1'] } }

  ## Callbacks
  after_update [:add_book_submission_points, :create_notification]
  before_save :normalize_url

  ## Extra methods
  
  def normalize_url
  	if self.publisher_website.present?
			self.publisher_website = self.publisher_website.normalize_url
		end
		if self.amazon.present?
  		self.amazon = self.amazon.normalize_url
		end	
  end

  # create notification
  def create_notification
    if self.pending == false and pending_changed?
    	Notification.create(:from_id => self.person.id, :book_id => self.id)
    	Notification.create(:to_id => self.person.id, :book_id => self.id)
    end
  end

  ## Random website
  def self.get_random
    self.active.find(:first, :conditions => ['pending <> true'], :order => 'RAND()')
  end

	## Books from same Author
	def sameAuthor n = Book.count
		Book.active.find(:all, :conditions => ['(author LIKE ?) AND id <> ?', self.author, self.id], :limit => n)
	end

	## People that Fav that Book
	def fans n = 0
		self.favorites.collect(&:person).reject { |p| p.hidden }
	end

  def add_book_submission_points
    if self.pending == false and pending_changed?
      ep = EarnedPoint.new
      ep.point = Point.find_by_reason('Submit Book')
      ep.person = self.person
      ep.rewardable = self
      ep.save

		  self.person.total_points = self.person.total_points + ep.point.quantity
		  self.person.save
		end
  end
  
  def remove_book_submission_points # points are removed when submited book is removed ("deleted")
    if self.hidden and self.pending == false
      ep = EarnedPoint.new
      ep.point = Point.find_by_reason('Book Removed')
      ep.person = self.person
      ep.rewardable = self
      ep.save
      
      self.person.total_points = self.person.total_points + ep.point.quantity
      self.person.save
    end
  end

  def update_book_featured_points option
    ep = EarnedPoint.new
		if option == "Featured"
    	ep.point = Point.find_by_reason('Book Featured')
		else
			ep.point = Point.find_by_reason('Book Unfeatured')
		end
    ep.person = self.person
    ep.rewardable = self
    ep.save

		self.person.total_points = self.person.total_points + ep.point.quantity
		self.person.save
  end

  def add_rate_points user
    ep = EarnedPoint.new
		ep.point = Point.find_by_reason('Rate Book')
    ep.person = user
    ep.rewardable = self
    ep.save

		user.total_points = user.total_points + ep.point.quantity
		user.save
  end
  
  ## LOGS
  def log_name
    self.title
  end
end

