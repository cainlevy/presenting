ENV["RAILS_ENV"] = "test"

# load the support libraries
require 'test/unit'
require 'rubygems'
require 'activesupport'
require 'actionpack'

# prepare for autoloading
ActiveSupport::Dependencies.load_paths << File.dirname(__FILE__) + '/../lib/'
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib/'

# load th ecode
require File.dirname(__FILE__) + '/../init'

