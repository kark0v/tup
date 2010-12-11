class CreateBooks < ActiveRecord::Migration
  def self.up
    create_table :books do |t|
      t.string :name
      t.string :author
      t.date :year_at
      t.string :language
      t.string :publisher
      t.string :amazon
      t.string :isbn
      t.integer :person_id

      t.timestamps
    end
  end

  def self.down
    drop_table :books
  end
end
