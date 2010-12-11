class AddFeaturedToWebsites < ActiveRecord::Migration
  def self.up
    add_column :websites, :featured, :boolean
  end

  def self.down
    remove_column :websites, :featured
  end
end
