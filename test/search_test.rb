require File.dirname(__FILE__) + '/test_helper'

class SearchTest < Presenting::Test
  def setup
    @s = Presentation::Search.new
  end
  
  # there's no configuration yet
end

class SearchRenderTest < Presentation::RenderTest
  def setup
    @presentation = Presentation::Search.new
    @presentation.controller = TestController.new
    @presentation.controller.request.path = '/users'
  end
  
  def test_rendering_a_form_reuses_current_path
    assert_select 'form[action=/users?][method=get]'
  end
  
  def test_rendering_a_search_box
    assert_select 'form input[type=text][name=search]'
  end
  
  def test_rendering_a_search_box_with_a_existing_search
    @presentation.controller.params[:search] = 'foo'
    assert_select 'form input[type=text][name=search][value=foo]'
  end
end
