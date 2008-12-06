require File.dirname(__FILE__) + '/test_helper'

class PresentationTest < Test::Unit::TestCase
  def test_rendering
    @p = Presenting::Grid.new(:id => "hello_world")
    puts @p.render
  end
end
