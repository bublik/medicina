require 'yaml'
require 'erb'
$KCODE = "utf8"
ENV['RAILS_ENV'] ||= 'development'
RAILS_GEM_VERSION = '2.3.5'

require File.join(File.dirname(__FILE__), 'boot')

erb_config = ERB.new(File.read(RAILS_ROOT + "/config/config.yml")).result
APP_CONFIG = YAML.load(erb_config)[RAILS_ENV]

Rails::Initializer.run do |config|
  # config.cache_store = :file_store, "#{RAILS_ROOT}/tmp/cache"
  config.time_zone = 'Kyev'
  
  #rake gems:install
  #config.gem 'haml'
  config.gem 'liquid'
  config.gem 'RedCloth'
  config.gem 'ya2yaml'
  config.gem 'i18n'#, :version => '= 0.3.0'
  config.gem 'russian', :lib => 'russian', :source => 'http://gems.github.com'
  config.gem 'will_paginate', :version => '2.3.14', :lib => 'will_paginate', :source => 'http://gems.github.com'
  
  config.action_view.sanitized_allowed_tags = ['strong', 'em', 'del', 'b', 'br', 'i', 'p', 'h1', 'h2','h3','h4','h5','h6', 'img', 'li', 'ul', 'ol']
  config.action_view.sanitized_allowed_attributes = ['id', 'class', 'style']

  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
   #config.plugins = [:active_sape, :acts_as_taggable_on_steroids, :attachment_fu, :jrails, :simple_captcha, :typus, :exception_notification]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  #config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
  #config.active_record.schema_format = :sql

  config.action_controller.session = {
    :session_key => '_med_session',
    :secret      => '54f13a4e5227c69eb9441a27ae29b7317b6d56879561feb97108b84b236824ac4543dd22c7c6548ab20b9aa21de3c2698fb5207732ff2efdb57c85c19f991f27'
  }

  config.i18n.load_path = config.i18n.load_path + Dir[Rails.root.join('locales', '*.{rb,yml}')] #Dir[File.join(RAILS_ROOT, 'config', 'locales', '**', '*.{rb,yml}')] 
  config.i18n.default_locale = APP_CONFIG['default_lang'].to_sym
  #config.log_level = :debug #for debug sape plugin
  config.cache_store = :mem_cache_store, { :namespace => "#{Date.today}-app-#{rand(10000)}" }
end

require 'globalize2-ar_cache-path'
