class Point < ActiveRecord::Base

  has_many :earned_points
  has_many :people, :through => :earned_points
end
