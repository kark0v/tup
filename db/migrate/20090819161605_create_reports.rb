class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.integer :reporter_id
      t.text :reasons
      t.integer :job_id
      t.integer :book_id
      t.integer :website_id
      t.integer :review_id
      t.integer :comment_id
      t.integer :person_id

      t.timestamps
    end
  end

  def self.down
    drop_table :reports
  end
end
