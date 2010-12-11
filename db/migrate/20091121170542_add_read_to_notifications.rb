class AddReadToNotifications < ActiveRecord::Migration
  def self.up
    add_column :notifications, :read, :integer, :default => false
  end

  def self.down
    remove_column :notifications, :read
  end
end
