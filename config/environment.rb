# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

# Configuración específica del proyecto
APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/config.yml")[RAILS_ENV]

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  config.load_paths += %W( #{RAILS_ROOT}/app/sweepers )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem 'chriseppstein-compass', :lib => 'compass'
  config.gem 'haml', :lib => 'haml', :version => '>=2.2.0'
  config.gem 'justinfrench-formtastic', :lib => 'formtastic'
  config.gem 'inherited_resources', :version => '1.0.3'
  # wget http://www.geocities.jp/kosako3/oniguruma/archive/onig-5.8.0.tar.gz
  # gem install -r ultraviolet --include-dependencies
  config.gem 'state_machine'
  config.gem 'vestal_versions'
  config.gem 'will_paginate', :version => '~> 2.3.11'
  config.gem 'searchlogic'
  config.gem 'spreadsheet'
  config.gem 'collectiveidea-delayed_job', :lib => 'delayed_job', :source => 'http://gems.github.com'
  config.gem 'RedCloth'
  

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  config.i18n.default_locale = :es
end

Harsh.enable_haml
