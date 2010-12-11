class FixReadFieldFromSuggestion < ActiveRecord::Migration
  def self.up
    remove_column :suggestions, :read
    add_column :suggestions, :read, :boolean, :default => false
  end

  def self.down
    remove_column :suggestions, :read
  end
end
