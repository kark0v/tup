class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.integer :person_id
			t.boolean :notification_messages, :default => true
			t.boolean :notification_reviews, :default => true
			t.boolean :notification_followers, :default => true
			t.boolean :notification_comment, :default => true
			t.boolean :notification_endorsement, :default => true
			
      t.timestamps
    end
  end

  def self.down
    drop_table :settings
  end
end
