require File.dirname(__FILE__) + '/test_helper'

class PresentationTest < Test::Unit::TestCase
  def test_rendering
    @p = Presentation::Grid.new(:id => "hello_world")
    html = @p.render
    assert_equal 'Hello World', html.strip
  end
end
