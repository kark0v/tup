class RefactoringRemove2 < ActiveRecord::Migration
  def self.up
	  add_column :reviews, :hidden, :boolean, :default => false
		add_column :comments, :hidden, :boolean, :default => false
  end

  def self.down
	  remove_column :reviews, :hidden
		remove_column :comments, :hidden
  end
end
