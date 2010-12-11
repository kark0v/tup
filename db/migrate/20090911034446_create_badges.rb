class CreateBadges < ActiveRecord::Migration
  def self.up
    create_table :badges do |t|
      t.string :description
      t.string :type
      t.string :color

      t.timestamps
    end

    create_table :earned_badges do |t|
      t.integer :badge_id
      t.integer :person_id

      t.timestamps
    end
  end

  def self.down
    drop_table :earned_badges
    drop_table :badges
  end
end
