class AddStatusConversationMembership2 < ActiveRecord::Migration
  def self.up
		remove_column :conversation_memberships, :status
		add_column :conversation_memberships, :status, :integer, :default => 1
  end

  def self.down
		remove_column :conversation_memberships, :status
  end
end
