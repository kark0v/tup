class CreatePoints < ActiveRecord::Migration
  def self.up
    create_table :points do |t|
      t.integer :rewardable_id
      t.string :rewardable_type

      t.string :reason # This *should* be just a template string, or something.

      t.timestamps
    end

    create_table :earned_points do |t|
      t.integer :point_id
      t.integer :person_id
      t.integer :quantity

      t.timestamps
    end
  end

  def self.down
    drop_table :earned_points
    drop_table :points
  end
end
