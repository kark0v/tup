class AddMessageToReports < ActiveRecord::Migration
  def self.up
		add_column :reports, :message_id, :integer
  end

  def self.down
		remove_column :reports, :message_id
  end
end
