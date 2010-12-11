class AddHiddenToJob < ActiveRecord::Migration
  def self.up
    add_column :jobs, :hidden, :boolean, :default => false
  end

  def self.down
    remove_column :jobs, :hidden
  end
end
