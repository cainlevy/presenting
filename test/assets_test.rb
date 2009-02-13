require File.dirname(__FILE__) + '/test_helper'
require 'action_controller/test_case'
require 'action_controller/integration'

class Presentation::StylesheetsControllerTest < ActionController::TestCase
  def test_stylesheet_routing_recognition
    assert_recognizes({:controller => "presentation/stylesheets", :action => "show", :id => "foo", :format => "css"}, "/presentation/stylesheets/foo.css")
  end
  
  def test_stylesheet_routing_generation
    assert_generates "/presentation/stylesheets/foo.css", {:controller => "presentation/stylesheets", :action => "show", :id => "foo", :format => "css"}
  end
  
  def test_named_stylesheet_routes
    assert_equal "/presentation/stylesheets/foo.css", presentation_stylesheet_path("foo", :format => 'css')
  end
  
  def test_retrieving_a_named_stylesheet
    get :show, :id => 'grid'
    assert_response :success
    assert_equal @response.body, File.read(File.join(PLUGIN_ROOT, 'app', 'assets', 'stylesheets', 'grid.css'))
  end
end
