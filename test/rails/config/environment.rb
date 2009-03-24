RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'mislav-will_paginate', :lib => 'will_paginate'
  config.time_zone = 'UTC'
  config.action_controller.session = {
    :session_key => '_presenting-app_session',
    :secret      => '7eac9f1cad277b81d353cd79968b7482107043cd00ad19ead80f8edf8094991a831e09e336255b5cb14305379636cd02bbc814bc820ae17c2fdaac892c8e7e06'
  }
  # This will load all plugins at the same level of this plugin
  config.plugin_paths = [File.join(File.dirname(__FILE__), *%w(.. .. .. ..))]
end
