# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_tup-1.0_session',
  :secret      => 'a46373bf4ab25b41987e216f4b1769890fc7ddc03a158dc30861717d22fd0387f1f370687fd1750616445ea6627c16984e96e601a021f6bace411f5df521cc68'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
