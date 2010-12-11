class AddFeaturedToBook < ActiveRecord::Migration
  def self.up
    add_column :books, :featured, :boolean, :default => false
  end

  def self.down
    remove_column :books, :featured
  end
end
