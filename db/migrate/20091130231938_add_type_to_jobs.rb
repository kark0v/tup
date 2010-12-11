class AddTypeToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :mode, :string, :default => 'Full-time'
		add_column :jobs, :duration, :string, :default => 'Permanent'
  end

  def self.down
    remove_column :jobs, :mode
		remove_column :jobs, :duration
  end
end
