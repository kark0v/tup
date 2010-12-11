class Listbooks < ActiveRecord::Base  

  ##Relationships
	belongs_to :person
	belongs_to :book
  
  ##Books status
  # finished = 1
  # reading = 2
  # reference = 3
  # want to read = 4
  # abandoned = 5
 
	
end
