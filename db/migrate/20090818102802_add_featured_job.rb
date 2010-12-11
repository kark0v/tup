class AddFeaturedJob < ActiveRecord::Migration
  def self.up
    add_column :jobs, :featured, :boolean, :default => false
  end

  def self.down
    remove_column :jobs, :featured
  end
end
