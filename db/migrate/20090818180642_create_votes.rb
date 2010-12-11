class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes, :force => true do |t|
      t.column :vote, :boolean, :default => false
      t.column :created_at, :datetime, :null => false
      t.column :voteable_type, :string, :limit => 15, :default => "", :null => false
      t.column :voteable_id, :integer, :default => 0, :null => false
      t.column :person_id, :integer, :default => 0, :null => false
    end

    add_index :votes, ["person_id"], :name => "fk_votes_person"
  end

  def self.down
    drop_table :votes
  end
end
