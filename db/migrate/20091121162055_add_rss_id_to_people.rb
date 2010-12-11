class AddRssIdToPeople < ActiveRecord::Migration
  def self.up
  	add_column :people, :rss_id, :string
  	add_index :people, :rss_id, :unique => true

  	# Generate an unique rss_id for every user that was already on the DB
  	Person.all.each do |p|
  		p.rss_id = p.create_rss_id
  		p.save
  	end

  end

  def self.down
  	remove_column :people, :rss_id
  	remove_index :people, :rss_id, :unique => true
  end
end
