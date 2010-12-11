class CreateConversationMembership < ActiveRecord::Migration

  def self.up
    drop_table :conversations_people

    create_table :conversation_memberships do |t|
      t.integer :conversation_id, :person_id
    end
  end

  def self.down
    drop_table :conversation_memberships
    create_table :conversations_people, :id => false do |t|
      t.integer :conversation_id, :person_id
    end
  end
end
