class RefactoringRemoves < ActiveRecord::Migration
  def self.up
	  add_column :websites, :hidden, :boolean, :default => false
		add_column :books, :hidden, :boolean, :default => false
		add_column :people, :hidden, :boolean, :default => false
  end

  def self.down
	  remove_column :websites, :hidden
		remove_column :books, :hidden
		remove_column :people, :hidden
  end
end
