ENV["RAILS_ENV"] = "test"

# load the support libraries
require 'test/unit'
require 'rubygems'
require 'activesupport'
require 'actionpack'
require 'action_controller'
require 'action_view'

# prepare for autoloading
ActiveSupport::Dependencies.load_paths << File.dirname(__FILE__) + '/../lib/'
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib/'

# load the code
require File.dirname(__FILE__) + '/../init'

