class Endorsement < ActiveRecord::Base
  belongs_to :endorser, :class_name => 'Person', :foreign_key => 'endorser_id'
  belongs_to :endorsee, :class_name => 'Person', :foreign_key => 'endorsee_id'

  named_scope :pending, :conditions => { :status => 0 }
  named_scope :accepted, :conditions => { :status => 1 }
  named_scope :refused, :conditions => { :status => 2 }
  
  after_create :send_notification_email
  
  def send_notification_email
    Mailer.deliver_endorsement_notification(self) if self.endorsee.setting.notification_endorsement
  end

  def status
    [:pending, :accepted, :refused][self.status]
  end

  def status= s
    write_attribute :status,  [:pending, :accepted, :refused].index(s)
  end

  def accept
    self.status= :accepted
    self.confirmed_at= Time.now
		
		self.add_endorsement_acceptance_points
  end

  def refuse
    self.status= :refused
    self.confirmed_at= Time.now
  end

  def add_endorsement_acceptance_points
    ## Points Endorser
		ep = EarnedPoint.new
   	ep.point = Point.find_by_reason('Endorse')
    ep.person = self.endorser
    ep.rewardable = self
    ep.save
		
		self.endorser.total_points = self.endorser.total_points + ep.point.quantity
		self.endorser.save

    ## Points Endorsee
		ep = EarnedPoint.new
   	ep.point = Point.find_by_reason('Get Endorsed')
    ep.person = self.endorsee
    ep.rewardable = self
    ep.save
		
		self.endorsee.total_points = self.endorsee.total_points + ep.point.quantity
		self.endorsee.save
  end
end
