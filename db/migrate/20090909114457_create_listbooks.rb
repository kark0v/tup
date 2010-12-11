class CreateListbooks < ActiveRecord::Migration
  def self.up
    create_table :listbooks do |t|
      t.integer :person_id
      t.integer :book_id
      t.integer :status
			t.boolean :wishlist
      t.boolean :recommend

      t.timestamps
    end
  end

  def self.down
    drop_table :listbooks
  end
end
