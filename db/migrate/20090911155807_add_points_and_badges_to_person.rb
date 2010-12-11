class AddPointsAndBadgesToPerson < ActiveRecord::Migration
  def self.up
		add_column :people, :total_points, :integer, :default => 0, :null => false
		add_column :people, :total_gold_badges, :integer, :default => 0, :null => false
		add_column :people, :total_silver_badges, :integer, :default => 0, :null => false
		add_column :people, :total_bronze_badges, :integer, :default => 0, :null => false
  end

  def self.down
		remove_column :people, :total_points
		remove_column :people, :total_gold_badges
		remove_column :people, :total_silver_badges
		remove_column :people, :total_bronze_badges
  end
end
