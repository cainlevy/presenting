# load the test app, which will load gems
ENV['RAILS_ENV'] = 'test'

if ENV['RAILS_VERSION'] == '4'
  require File.join(File.dirname(__FILE__), 'r4', 'config', 'environment.rb')
else
  require File.join(File.dirname(__FILE__), 'r3', 'config', 'environment.rb')
end

require 'test/unit/testcase'
require 'rails/test_help'

Rails.backtrace_cleaner.remove_silencers!

# a way to customize syntax for our tests
class Presenting::Test < Test::Unit::TestCase
  # TODO: create a shoulda-like context/setup/should syntax
  def default_test; end # to quiet Test::Unit
end

# inheriting tests should target rendering behavior given certain configurations
class Presentation::RenderTest < Presenting::Test
  include ActionDispatch::Assertions::SelectorAssertions

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
