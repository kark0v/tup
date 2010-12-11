class EarnedBadge < ActiveRecord::Base
  belongs_to :person
  belongs_to :badge
end
