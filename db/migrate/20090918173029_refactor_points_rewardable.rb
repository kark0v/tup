class RefactorPointsRewardable < ActiveRecord::Migration
  def self.up
    remove_column :points, :rewardable_id
    remove_column :points, :rewardable_type
    add_column :earned_points, :rewardable_id, :integer
    add_column :earned_points, :rewardable_type, :string
  end

  def self.down
    remove_column :earned_points, :rewardable_id
    remove_column :earned_points, :rewardable_type
    add_column :points, :rewardable_id, :integer
    add_column :points, :rewardable_type, :string
  end
end
