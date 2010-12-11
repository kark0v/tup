class CreateNotificationconversations < ActiveRecord::Migration
  def self.up
    create_table :notificationconversations do |t|
    	t.integer :person_id
    	t.integer :notification_id
    	t.text :message

      t.timestamps
    end
  end

  def self.down
    drop_table :notificationconversations
  end
end
