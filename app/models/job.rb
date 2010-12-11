class Job < ActiveRecord::Base

  belongs_to :person

  ## Relationships
  has_many :suggestions
	has_many :reports
  has_many :favorites

  ## Named scopes
  named_scope :recently_submited, lambda { |n| { :limit => n, :conditions => ['hidden <> true'], :order => "created_at DESC" } }
	named_scope :active, lambda { |n| { :limit => n, :conditions => ['hidden <> true'] } }
	named_scope :featured, lambda { |n| { :limit => n, :conditions => ['hidden <> true AND featured = true'] } }
	named_scope :open, lambda { |n| { :limit => n, :conditions => ['hidden <> true AND status = ?', "open"] } }
	named_scope :closed, lambda { |n| { :limit => n, :conditions => ['hidden <> true AND  status = ?', "closed"] } }

  ## Callbacks
  after_create [:add_job_submission_points, :create_notification]
  before_save :normalize_url

  ## Extra methods

  # create notification
  def create_notification
  	Notification.create(:from_id => self.person.id, :job_id => self.id)
  end
  
  def normalize_url
  	self.company_website = self.company_website.normalize_url
  end

  def open?
    self.status == "open"
  end

	def similar n = Job.count
		Job.active.find(:all, :conditions => ['(role LIKE ?) AND id <> ?', self.role, self.id], :limit => n)
	end

	def same_recruiter n = Job.count
		Job.active.find(:all, :conditions => ['person_id = ? AND id <> ?', self.person, self.id], :limit => n)
	end

	def same_company n = Job.count
		Job.active.find(:all, :conditions => ['company = ? AND id <> ?', self.company, self.id], :limit => n)
	end

  def add_job_submission_points
    ep = EarnedPoint.new
    ep.point = Point.find_by_reason('Submit Job')
    ep.person = self.person
    ep.rewardable = self
    ep.save

		self.person.total_points = self.person.total_points + ep.point.quantity
		self.person.save
  end

  def update_job_featured_points option
    ep = EarnedPoint.new
		if option == "Featured"
    	ep.point = Point.find_by_reason('Job Featured')
		else
			ep.point = Point.find_by_reason('Job Unfeatured')
		end
    ep.person = self.person
    ep.rewardable = self
    ep.save

		self.person.total_points = self.person.total_points + ep.point.quantity
		self.person.save
  end
  
  ## LOGS
  def log_name
    self.role
  end
end
