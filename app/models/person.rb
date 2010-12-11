class Person < ActiveRecord::Base

  ## Behaviours

  acts_as_authentic do |c|
    c.login_field :email
    #c.require_password_confirmation = false
    c.perishable_token_valid_for = 24.hours
  end

  acts_as_authorized_user
  acts_as_authorizable

  ## Validations
  validates_length_of :name, :maximum => 50

  ## Relationships

  has_many :jobs
	has_many :books
  has_many :websites
  has_many :reviews, :order => 'created_at DESC'
  has_many :comments
  has_and_belongs_to_many :followers, :join_table => :followership, :class_name => 'Person', :foreign_key => :followed_id, :association_foreign_key => :follower_id, :uniq => true
  has_and_belongs_to_many :followed, :join_table => :followership, :class_name => 'Person', :foreign_key => :follower_id, :association_foreign_key => :followed_id, :uniq => true

  has_and_belongs_to_many :blocked, :join_table => :blocks, :class_name => 'Person', :foreign_key => :blockee_id, :association_foreign_key => :blocker_id, :uniq => true
  has_and_belongs_to_many :blockers, :join_table => :blocks, :class_name => 'Person', :foreign_key => :blocker_id, :association_foreign_key => :blockee_id, :uniq => true

  has_many :conversation_memberships
  has_many :conversations, :through => :conversation_memberships
  has_many :messages

	has_many :suggestions, :class_name => 'Suggestion', :foreign_key => :suggest_to_id
	has_many :suggested, :class_name => 'Suggestion', :foreign_key => :suggester_id

  has_many :endorsements, :foreign_key => 'endorsee_id'
  has_many :endorsed, :foreign_key => 'endorser_id'

  has_many :favorites
	has_many :listbookss

  has_many :earned_badges
  has_many :badges, :through => :earned_badges

  has_many :earned_points, :order => 'created_at DESC'
  has_many :points, :through => :earned_points

	has_one :setting


  has_attached_file :photo,
    :default_url => "/images/profile.jpg",
    :styles => {
      :full => '272x272>',
      :thumb => "72x72#",
			:small => "32x32#"
    }
	#validates_attachment_size :photo, :less_than => 2.megabytes
	#validates_attachment_content_type :photo,
	#	:content_type => [
	#		'image/jpeg',
	#		'image/pjpeg', # for progressive jpeg (IE mine-type for regular jpeg)
	#		'image/png',
	#		'image/x-png', # IE mine-type for PNG
	#		'image/gif'
	#]


  ## Named scopes
  named_scope :recently_joined, lambda { |n| { :limit => n, :conditions => ['hidden <> true'], :order => "created_at DESC" } }
	named_scope :active, lambda { |n| { :limit => n, :conditions => ['hidden <> true AND email <> ?', "theusabilitypage@gmail.com"] } }

  ## Callbacks
  after_create [:add_registration_points, :add_rss_id, :create_settings]
  after_update :add_complete_profile_points
  before_save :normalize_url

  ## Extra methods

  def normalize_url
  	self.homepage = self.homepage.normalize_url if self.homepage
  end

  # create notifications
  def self.create_notifications(from_id, to_id)
  	# creates 2 notifications, one for direct notification,
  	# and one for network notifications
  	Notification.create(:from_id => from_id, :to_id => to_id)
  	Notification.create(:from_id => from_id, :other_id => to_id)
  end

  def reset_password
  	self.reset_perishable_token!
  	Mailer.deliver_password_reset_intructions(self)
  end

  def is_tup?
    self.email == "theusabilitypage@gmail.com"
  end

	def follows? person
    self.followed.include? person
  end

  def blocked_by? person
    self.blockers.include? person
  end

  def blocks? person
    self.blocked.include? person
  end

  def job_favs? job
		self.favorites.collect(&:job).include? job
  end

  def website_favs? website
		self.favorites.collect(&:website).include? website
  end

  def book_favs? book
		self.favorites.collect(&:book).include? book
  end

  def fav_books
		self.favorites.collect(&:book).reject(&:nil?).reject { |book| book.hidden }
  end

  def book_onlist? book
		self.listbookss.collect(&:book).include? book
  end

  def is_admin?
  	self.has_role? "tup_member"
  end

  def has_role? role, authorized_object = nil
    return authorized_object == self if role == "owner"
    return follows?(authorized_object) if role == "follower"
    return blocks?(authorized_object) if role == "blocker"
    return blocked_by?(authorized_object) if role == "blocked"
    super
  end

	def self.recruiters n = nil
		people = Job.active.collect(&:person).reject { |p| p.hidden }.uniq.shuffle
    people = people.first(n) unless n.nil?
    return people
	end
	
	def latest_action
	  (Book.find(:all, :conditions => ['person_id = ? and pending = ?', self.id, false], :include => :person)+Website.find(:all, :conditions => ['person_id = ?', self.id], :include => :person)+Job.find(:all, :conditions => ['person_id = ?', self.id], :include => :person)+Review.find(:all, :conditions => ['person_id = ?', self.id], :include => [:person, :book, :website])).sort{ |x,y| y.created_at <=> x.created_at }.first
	end
	
	def self.latest_contributors(num_people = 3)
	  (Book.find(:all, :conditions => ['pending = ?', false], :include => :person)+Website.find(:all, :include => :person)+Job.find(:all, :include => :person)+Review.find(:all, :include => [:person, :book, :website])).sort{ |x,y| y.created_at <=> x.created_at }.map(&:person).uniq[0, num_people]
	end

  def add_registration_points
    ep = EarnedPoint.new
    ep.point = Point.find_by_reason('Register')
    ep.person = self
    ep.rewardable = self
    ep.save

		self.total_points = self.total_points + ep.point.quantity
		self.save
  end

  def add_rss_id
  	self.rss_id = self.create_rss_id
  	self.save
  end

  def create_settings
  	Setting.create(:person_id => self.id)
  end

  def add_complete_profile_points
    if self.name && self.email && self.homepage && self.photo && self.professional_headline
			exist_ep = EarnedPoint.find(
				:all,
				:include => :point,
				:conditions => ['person_id = ? and points.reason = "Complete Profile"', self]
			)
			if exist_ep.size == 0
				ep = EarnedPoint.new
				ep.point = Point.find_by_reason('Complete Profile')
				ep.person = self
				ep.rewardable = self
				ep.save

				self.total_points = self.total_points + ep.point.quantity
				self.save
			end
		end
  end


  def add_follow_points follower
    ep = EarnedPoint.new
   	ep.point = Point.find_by_reason('Follow')
    ep.person = self
    ep.rewardable = follower
    ep.save

		self.total_points = self.total_points + ep.point.quantity
		self.save
  end

  def remove_unfollow_points follower
    ep = EarnedPoint.new
   	ep.point = Point.find_by_reason('Unfollow')
    ep.person = self
    ep.rewardable = follower
    ep.save

		self.total_points = self.total_points + ep.point.quantity
		self.save
  end

  def create_rss_id
  	rss_id_digest = Digest::MD5.hexdigest(self.email + self.created_at.to_s)
  	rss = Person.find(:first, :conditions => ['rss_id = ?', rss_id_digest])

  	while rss
  		rss_id_digest = Digest::MD5.hexdigest(self.email + self.created_at.to_s + rand.to_s)
  		rss = Person.find(:first, :conditions => ['rss_id = ?', rss_id_digest])
  	end
  	rss_id_digest
  end

  def self.new_pwd
  	char_list = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
		code = ""
		8.times do
			code << char_list[rand(char_list.size-1)]
		end
		return code
  end
end

