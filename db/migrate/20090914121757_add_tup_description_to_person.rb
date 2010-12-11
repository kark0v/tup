class AddTupDescriptionToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :tup_description, :text
  end

  def self.down
    remove_column :people, :tup_description
  end
end
