class Conversation < ActiveRecord::Base

  has_many :conversation_memberships
  has_many :people, :through => :conversation_memberships
  has_many :messages

  #after_create :save_message

  ## Named scopes
	named_scope :active, lambda { |n| { :limit => n, :include => 'conversation_memberships', :conditions => ['conversation_memberships.status = 1'] } }

	def active_people
		self.people.find(:all, :conditions => ['conversation_memberships.status = 1'])
	end

	def already_added? person
    self.people.include? person
  end

  def person_attributes= attributes
    attributes.each do |id, person|
      people << Person.find(id)
    end
  end

  def initial_message= attributes
    messages.build(attributes)
  end

  def save_message
    messages.each do |message|
      message.save
    end
  end

end

