class CreateConversations < ActiveRecord::Migration
  def self.up
    create_table :conversations do |t|
      t.string :title

      t.timestamps
    end

    create_table :conversations_people, :id => false do |t|
      t.integer :conversation_id, :person_id
    end

  end

  def self.down
    drop_table :conversations_people
    drop_table :conversations
  end
end
