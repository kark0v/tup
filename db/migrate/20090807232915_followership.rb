class Followership < ActiveRecord::Migration
  def self.up
    create_table :followership, :id => false do |t|
      t.integer :follower_id, :followed_id
    end
  end

  def self.down
    drop_table :followership
  end
end
