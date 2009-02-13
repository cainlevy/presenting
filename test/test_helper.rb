ENV["RAILS_ENV"] = "test"

# load the support libraries
require 'test/unit'
require 'rubygems'
gem 'rails', '2.3.0'
require 'activesupport'
require 'actionpack'
require 'action_controller'
require 'action_view'
require 'mocha'

PLUGIN_ROOT = File.join(File.dirname(__FILE__), '..')

# prepare for autoloading
ActiveSupport::Dependencies.load_paths << File.join(PLUGIN_ROOT, 'lib')
$LOAD_PATH.unshift File.join(PLUGIN_ROOT, 'lib')

# load the code -- should be automatically done in an application from rails 2.3+
ActionController::Base.view_paths << File.join(PLUGIN_ROOT, 'app', 'views')
ActiveSupport::Dependencies.load_paths << File.join(PLUGIN_ROOT, 'app', 'controllers')
$LOAD_PATH.unshift File.join(PLUGIN_ROOT, 'app', 'controllers')
require File.join(PLUGIN_ROOT, 'routes')
require File.join(PLUGIN_ROOT, 'init')

class Test::Unit::TestCase
  include ActionController::Assertions::SelectorAssertions

  protected
  
  def response_from_page_or_rjs
    html_document.root
  end
  
  def html_document
    HTML::Document.new(@render)
  end  
end
