class EarnedPoint < ActiveRecord::Base
  belongs_to :rewardable, :polymorphic => true

  belongs_to :person
  belongs_to :point
end
