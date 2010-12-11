class Website < ActiveRecord::Base
  acts_as_taggable_on :tags
  acts_as_rateable

  ## Relationships

  belongs_to :person
  has_many :screenshots
  has_many :reviews
	has_many :reports
	has_many :favorites
  after_update :save_screenshots

  has_many :points, :as => :rewardable

  #Add screenshot when creating or editing a new website

  def screenshots_fields=(screenshots_fields)
    screenshots_fields.each do |screenshot|
      screenshots.build(screenshot)
     end
  end

  #Remove? screenshot when editing a website
  def screenshots_edit_fields=(screenshots_fields)
    screenshots_fields.each do |id, attributes|
      screenshot = screenshots.detect { |t| t.id == attributes[:id].to_i }
      if attributes[:should_destroy].to_i == 1
        screenshot.should_destroy = 1
      end
    end
  end

  def save_screenshots
    screenshots.each do |t|
      if t.should_destroy?
        t.destroy
      else
        t.save(false)
      end
    end
  end
  
  ##
  default_scope :order => 'created_at DESC'

  ## Named scopes
  named_scope :recently_submited, lambda { |n| { :limit => n, :conditions => ['hidden <> true'], :order => "created_at DESC" } }
  named_scope :featured, lambda { |n| { :limit => n, :conditions => ['hidden <> true AND featured = true'], :order => 'created_at DESC' } }
	named_scope :active, lambda { |n| { :limit => n, :conditions => ['hidden <> true'], :order => 'created_at DESC' } }

  ## Callbacks
  after_create [:add_website_submission_points, :create_notification]
  before_save :normalize_url

	## Extra methods
	
	def normalize_url
		self.url = self.url.normalize_url
	end

	# create notification
	def create_notification
		Notification.create(:from_id => self.person.id, :website_id => self.id)
	end

  ## Random website
  def self.get_random
    self.active.find(:first, :order => 'RAND()')
  end

	def samesubmitter n = Website.count
		Website.active.find(:all, :conditions => ['person_id = ? AND id <> ?', self.person, self.id], :limit => n)
	end


	## People that Fav that Website
	def fans n = 0
		self.favorites.collect(&:person).reject { |p| p.hidden }
	end

  def add_website_submission_points
    ep = EarnedPoint.new
    ep.point = Point.find_by_reason('Submit Website')
    ep.person = self.person
    ep.rewardable = self
    ep.save

		self.person.total_points = self.person.total_points + ep.point.quantity
		self.person.save
  end
  
  def remove_website_submission_points # points are removed when submited website is removed ("deleted")
    if self.hidden
      ep = EarnedPoint.new
      ep.point = Point.find_by_reason('Website Removed')
      ep.person = self.person
      ep.rewardable = self
      ep.save
      
      self.person.total_points = self.person.total_points + ep.point.quantity
      self.person.save
    end
  end

  def update_website_featured_points option
    ep = EarnedPoint.new
		if option == "Featured"
    	ep.point = Point.find_by_reason('Website Featured')
		else
			ep.point = Point.find_by_reason('Website Unfeatured')
		end
    ep.person = self.person
    ep.rewardable = self
    ep.save

		self.person.total_points = self.person.total_points + ep.point.quantity
		self.person.save
  end

  def add_rate_points user
    ep = EarnedPoint.new
		ep.point = Point.find_by_reason('Rate Website')
    ep.person = user
    ep.rewardable = self
    ep.save

		user.total_points = user.total_points + ep.point.quantity
		user.save
  end
  
  ## LOGS
  def log_name
    self.name
  end
end
