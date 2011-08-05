ENV["RAILS_ENV"] = "test"

# load the support libraries
require 'test/unit'
require 'rubygems'
gem 'rails', '2.3.11'
require 'active_support'
require 'action_pack'
require 'action_controller'
require 'action_view'
require 'mocha'
require 'will_paginate'
WillPaginate.enable_actionpack

GEM_ROOT = File.join(File.dirname(__FILE__), '..')

# prepare for autoloading
ActionController::Base.view_paths << File.join(GEM_ROOT, 'app', 'views')
ActiveSupport::Dependencies.autoload_paths << File.join(GEM_ROOT, 'app', 'controllers')
$LOAD_PATH.unshift File.join(GEM_ROOT, 'app', 'controllers')

# set up the asset routes, and an extra resource for tests that generate normal routes
require File.join(GEM_ROOT, 'config', 'routes')
ActionController::Routing::Routes.draw do |map| map.resources :users end

# load the code
$LOAD_PATH.unshift File.join(GEM_ROOT, 'lib') # needed when running test files w/o rake
require File.join(GEM_ROOT, 'lib', 'presenting')

class TestController < ActionController::Base
  attr_accessor :request, :response, :params

  def initialize
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    
    @params = {}
    send(:initialize_current_url)
  end
end

# a way to customize syntax for our tests
class Presenting::Test < Test::Unit::TestCase
  # TODO: create a shoulda-like context/setup/should syntax
  def default_test; end # to quiet Test::Unit
end

# inheriting tests should target rendering behavior given certain configurations
class Presentation::RenderTest < Presenting::Test
  include ActionController::Assertions::SelectorAssertions

  protected
  
  def render
    @render ||= @presentation.render
  end
  
  def response_from_page_or_rjs
    html_document.root
  end
  
  def html_document
    HTML::Document.new(render)
  end
end
