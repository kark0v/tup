class AddStatusConversationMembership < ActiveRecord::Migration
  def self.up
		add_column :conversation_memberships, :status, :integer
		add_column :conversation_memberships, :created_at, :timestamp
		add_column :conversation_memberships, :updated_at, :timestamp
  end

  def self.down
		remove_column :conversation_memberships, :status
		remove_column :conversation_memberships, :created_at
		remove_column :conversation_memberships, :updated_at
  end
end
