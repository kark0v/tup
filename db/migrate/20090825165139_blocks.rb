class Blocks < ActiveRecord::Migration
  def self.up
    create_table :blocks, :id => false do |t|
      t.integer :blocker_id, :blockee_id
    end
  end

  def self.down
    drop_table :blocks
  end
end
