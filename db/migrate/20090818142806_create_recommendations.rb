class CreateRecommendations < ActiveRecord::Migration
  def self.up
    create_table :recommendations do |t|
      t.integer :recommender_id
      t.integer :recommend_to_id
      t.integer :job_id

      t.timestamps
    end
  end

  def self.down
    drop_table :recommendations
  end
end
