class MoveThePointQuantity < ActiveRecord::Migration
  def self.up
    remove_column :earned_points, :quantity
    add_column :points, :quantity, :integer
  end

  def self.down
    add_column :earned_points, :quantity, :integer
    remove_column :points, :quantity
  end
end
