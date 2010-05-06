# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_BirthdayReminder_session',
  :secret      => '87720be2633d1d60cb52c677b77d6d462aba4eb9226284d32832ba75a317f5d2a0717aa7118cb617505ef66c953ec1cb59f2e9bacaee1defafeadf1a664f4040'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
