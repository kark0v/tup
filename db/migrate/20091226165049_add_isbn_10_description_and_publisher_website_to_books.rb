class AddIsbn10DescriptionAndPublisherWebsiteToBooks < ActiveRecord::Migration
  def self.up
  	add_column :books, :isbn_10, :string
  	add_column :books, :description, :text
  	add_column :books, :publisher_website, :string
  end

  def self.down
  	remove_column :books, :isbn_10
  	remove_column :books, :description
  	remove_column :books, :publisher_website
  end
end
