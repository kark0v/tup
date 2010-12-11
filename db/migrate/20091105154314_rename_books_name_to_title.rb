class RenameBooksNameToTitle < ActiveRecord::Migration
  def self.up
    remove_column :books, :name
    add_column :books, :title, :string
  end

  def self.down
    remove_column :books, :title
    add_column :books, :name, :string
  end
end
