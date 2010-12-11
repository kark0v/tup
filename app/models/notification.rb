class Notification < ActiveRecord::Base

	# Types of notifications
	#
	# from & to -> 'from' added 'to' to his network
	# from & other -> 'from' added 'other' to his network and from is in your network
	#

	belongs_to :from,
		:class_name => 'Person',
		:foreign_key => :from_id
	belongs_to :to,
		:class_name => 'Person',
		:foreign_key => :to_id
	belongs_to :other,
		:class_name => 'Person',
		:foreign_key => :other_id
	belongs_to :job
	belongs_to :book
	belongs_to :website
	belongs_to :review
	belongs_to :comment
	belongs_to :favorite
	belongs_to :notification

	has_many :notificationconversations

end

