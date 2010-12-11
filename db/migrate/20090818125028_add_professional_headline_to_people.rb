class AddProfessionalHeadlineToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :professional_headline, :string
  end

  def self.down
    remove_column :people, :professional_headline
  end
end
