class Suggestion < ActiveRecord::Base

  belongs_to :suggester, :class_name => "Person", :foreign_key => :suggester_id
	belongs_to :person, :class_name => "Person", :foreign_key => :suggest_to_id
	belongs_to :job
	belongs_to :book
	
end
