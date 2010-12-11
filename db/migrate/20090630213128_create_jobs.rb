class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.string :company
      t.string :role
      t.text :description
      t.text :howtoapply
      t.date :deadline_at
      t.integer :person_id

      t.timestamps
    end
  end

  def self.down
    drop_table :jobs
  end
end
