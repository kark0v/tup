class MoveRecommendationToSuggestion < ActiveRecord::Migration
  def self.up
    rename_table :recommendations, :suggestions
    rename_column :suggestions, :recommender_id, :suggester_id
    rename_column :suggestions, :recommend_to_id, :suggest_to_id
  end

  def self.down
    rename_column :suggestions, :suggest_to_id, :recommend_to_id
    rename_column :suggestions, :suggester_id,  :recommender_id
    rename_table :suggestions, :recommendations
  end
end
