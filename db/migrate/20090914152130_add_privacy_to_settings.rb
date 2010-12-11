class AddPrivacyToSettings < ActiveRecord::Migration
  def self.up
		add_column :settings, :privacy_websites, :integer, :default => 0, :null => false
		add_column :settings, :privacy_books, :integer, :default => 0, :null => false
		add_column :settings, :privacy_endorsements, :integer, :default => 0, :null => false
		add_column :settings, :privacy_network, :integer, :default => 0, :null => false
		add_column :settings, :privacy_search, :boolean, :default => true, :null => false
  end

  def self.down
		remove_column :settings, :privacy_websites
		remove_column :settings, :privacy_books
		remove_column :settings, :privacy_endorsements
		remove_column :settings, :privacy_network
		remove_column :settings, :privacy_search
  end
end
