class AddFieldToSuggestion < ActiveRecord::Migration
  def self.up
    add_column :suggestions, :read, :boolean
  end

  def self.down
    remove_column :suggestions, :read
  end
end
