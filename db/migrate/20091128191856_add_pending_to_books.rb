class AddPendingToBooks < ActiveRecord::Migration
  def self.up
    add_column :books, :pending, :boolean, :default => true
  end

  def self.down
    remove_column :books, :pending
  end
end

