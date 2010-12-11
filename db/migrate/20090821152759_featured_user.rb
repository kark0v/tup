class FeaturedUser < ActiveRecord::Migration
  def self.up
    add_column :people, :featured, :boolean, :default => false
  end

  def self.down
    remove_column :people, :featured
  end
end
