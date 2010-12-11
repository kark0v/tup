class Badge < ActiveRecord::Base
  has_many :earned_badges
  has_many :people, :through => :earned_badges
end
