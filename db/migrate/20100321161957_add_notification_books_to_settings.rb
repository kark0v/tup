class AddNotificationBooksToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :notification_books, :boolean, :default => true
    Setting.update_all(:notification_books => true)
  end

  def self.down
    remove_column :settings, :notification_books
  end
end
