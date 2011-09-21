require File.dirname(__FILE__) + '/test_helper'

class Presentation::AssetsControllerTest < ActionController::TestCase

  def setup
    ActionController::Base.perform_caching = false
  end

  # stylesheet

  def test_stylesheet_routing_recognition
    assert_recognizes({:controller => "presentation/assets", :action => "stylesheet", :id => "foo", :format => "css"}, "/presentation/stylesheets/foo.css")
  end
  
  def test_stylesheet_routing_generation
    assert_generates "/presentation/stylesheets/foo.css", {:controller => "presentation/assets", :action => "stylesheet", :id => "foo", :format => "css"}
  end
  
  def test_named_stylesheet_routes
    assert_equal "/presentation/stylesheets/foo.css", presentation_stylesheet_path("foo", :format => 'css')
  end

  def test_retrieving_a_named_stylesheet
    get :stylesheet, :id => 'grid', :format => 'css'
    assert_response :success
    assert_equal @response.body, File.read(File.join('app', 'assets', 'stylesheets', 'grid.css'))
  end
  
  def test_retrieving_multiple_named_stylesheets
    get :stylesheet, :id => 'grid,form', :format => 'css'
    assert_response :success
    assert @response.body.include?(File.read(File.join('app', 'assets', 'stylesheets', 'grid.css')))
    assert @response.body.include?(File.read(File.join('app', 'assets', 'stylesheets', 'form.css')))
  end
  
  # javascript

  def test_javascript_routing_recognition
    assert_recognizes({:controller => "presentation/assets", :action => "javascript", :id => "foo", :format => "js"}, "/presentation/javascript/foo.js")
  end
  
  def test_javascript_routing_generation
    assert_generates "/presentation/javascript/foo.js", {:controller => "presentation/assets", :action => "javascript", :id => "foo", :format => "js"}
  end
  
  def test_named_javascript_routes
    assert_equal "/presentation/javascript/foo.js", presentation_javascript_path("foo", :format => 'js')
  end
  
  def test_retrieving_multiple_named_javascripts
    get :javascript, :id => 'grid,search', :format => 'js'
    assert_response :success
    assert @response.body.include?(File.read(File.join('app', 'assets', 'javascripts', 'grid.js')))
    assert @response.body.include?(File.read(File.join('app', 'assets', 'javascripts', 'search.js')))
  end
end
