class Report < ActiveRecord::Base

  belongs_to :reporter, :class_name => "Person", :foreign_key => :reporter_id
	belongs_to :person, :class_name => "Person", :foreign_key => :person_id
	belongs_to :job
  belongs_to :book
	belongs_to :website
	belongs_to :review
	belongs_to :comment
	belongs_to :message
	
end
