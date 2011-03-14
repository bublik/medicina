#ActionController::Base.session = {
#  :key => '_medicina_session',
#  #:domain => ".#{APP_CONFIG['domain']}",
#  :expire_after => 14.days,
#}

# (create the session table with "rake db:sessions:create")
 ActionController::Base.session_store = :active_record_store
