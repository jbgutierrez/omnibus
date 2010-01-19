# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ppee_tests_cli_session',
  :secret      => '20fcc0f5189f1d31959406430dc8b15eff8385182ae744a094bc742488c46074f71ea8608ff403db802ae508bd7a649540c4bb29b811e84be1661e5e1f173e15'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
