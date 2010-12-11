class UpdateListbookstable < ActiveRecord::Migration
  def self.up
    remove_column :listbooks, :wishlist
  end

  def self.down
    add_column :listbooks, :wishlist, :boolean
  end
end
