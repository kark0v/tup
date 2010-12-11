class AddBookToSuggestion < ActiveRecord::Migration
  def self.up
    add_column :suggestions, :book_id, :integer
  end

  def self.down
    remove_column :suggestions, :book_id
  end
end
