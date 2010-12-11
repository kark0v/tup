class CreateEndorsements < ActiveRecord::Migration
  def self.up
    create_table :endorsements do |t|
      t.integer :endorser_id
      t.integer :endorsee_id
      t.text :body
      t.integer :status, :default => 0
      t.timestamp :confirmed_at

      t.timestamps
    end
  end

  def self.down
    drop_table :endorsements
  end
end
