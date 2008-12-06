ENV["RAILS_ENV"] = "test"

# load the support libraries
require 'test/unit'
require 'rubygems'
require 'activesupport'
require 'actionpack'
require 'action_controller'
require 'action_controller/assertions'
require 'action_view'
require 'mocha'

# prepare for autoloading
ActiveSupport::Dependencies.load_paths << File.dirname(__FILE__) + '/../lib/'
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib/'

# load the code
require File.dirname(__FILE__) + '/../init'

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
