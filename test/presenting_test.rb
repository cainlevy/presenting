require File.dirname(__FILE__) + '/test_helper'

class PresentationTest < Test::Unit::TestCase
  
  def test_rendering
    # TODO: create a "hello world" test-only setup so i can test rendering
    @p = Presentation::Grid.new(:id => "hello_world")
    @p.presentable = []
    assert_nothing_raised do
      assert @p.render
    end
  end
  
end
