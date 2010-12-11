class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.integer :from_id
      t.integer :to_id
      t.integer :other_id
      t.integer :job_id
      t.integer :book_id
      t.integer :website_id
      t.integer :review_id
      t.integer :comment_id
      t.integer :favorite_id

      t.timestamps
    end
  end

  def self.down
    drop_table :notifications
  end
end
