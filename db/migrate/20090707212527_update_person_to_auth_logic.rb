class UpdatePersonToAuthLogic < ActiveRecord::Migration
  def self.up
    change_table :people do |t|
      t.string   "crypted_password",                   :null => false
      t.string   "password_salt",                      :null => false
      t.string   "persistence_token",                  :null => false
      t.string   "single_access_token",                :null => false
      t.string   "perishable_token",                   :null => false
      t.integer  "login_count",         :default => 0, :null => false
      t.integer  "failed_login_count",  :default => 0, :null => false
      t.datetime "last_request_at"
      t.datetime "current_login_at"
      t.datetime "last_login_at"
      t.string   "current_login_ip"
      t.string   "last_login_ip"
    end
  end

  def self.down
    change_table :people do |t|
      t.delete   "crypted_password"
      t.delete   "password_salt"
      t.delete   "persistence_token"
      t.delete   "single_access_token"
      t.delete   "perishable_token"
      t.delete  "login_count"
      t.delete  "failed_login_count"
      t.delete "last_request_at"
      t.delete "current_login_at"
      t.delete "last_login_at"
      t.delete   "current_login_ip"
      t.delete   "last_login_ip"
    end
  end
end
