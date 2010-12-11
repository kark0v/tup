class AddTypeStatusWebsiteToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :company_website, :string
		add_column :jobs, :status, :string, :null => false, :default => 'open'
  end

  def self.down
		remove_column :jobs, :company_website
		remove_column :jobs, :status
  end
end
