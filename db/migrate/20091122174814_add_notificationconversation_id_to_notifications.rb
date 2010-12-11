class AddNotificationconversationIdToNotifications < ActiveRecord::Migration
  def self.up
    add_column :notifications, :notification_id, :integer
  end

  def self.down
    remove_column :notifications, :notification_id
  end
end
