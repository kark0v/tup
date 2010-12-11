class CreateScreenshots < ActiveRecord::Migration
  def self.up
    create_table :screenshots do |t|
      t.integer :website_id
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      
      t.timestamps
    end
  end

  def self.down
    drop_table :screenshots
  end
end
