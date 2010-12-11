class AddFieldsToWebsite < ActiveRecord::Migration
  def self.up
    add_column :websites, :nviews, :integer
    add_column :websites, :version, :integer
    add_column :websites, :previous_id, :integer
  end

  def self.down
    remove_column :websites, :previous_id
    remove_column :websites, :version
    remove_column :websites, :nviews
  end
end
