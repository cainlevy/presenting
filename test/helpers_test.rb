require File.dirname(__FILE__) + '/test_helper'
require 'action_view/test_case'

class Presenting::HelpersTest < ActionView::TestCase
  
  def test_presenting_a_boolean
    assert_equal 'False', present(false)
    assert_equal 'True', present(true)
  end
  
  def test_presenting_a_nil
    assert_equal "", present(nil)
  end
  
  def test_presenting_an_array_creates_an_ordered_list
    assert present(['hello', 'world']) =~ %r|^<ol>.*</ol>$|
  end
  
  def test_presenting_an_array_presents_the_members
    assert present([true]).include?("<li>True</li>")
  end
  
  def test_presenting_a_hash_creates_a_definition_list
    assert present({1 => 'a'}) =~ %r|^<dl>.*</dl>$|
  end
  
  def test_presenting_a_hash_sorts_by_hash_keys
    assert present({1 => 'a', 4 => 'd', 3 => 'c', 2 => 'b'}) =~ /^.*a.*b.*c.*d.*$/
  end
  
  def test_presenting_a_hash_presents_the_values
    assert present({1 => true}).include?("<dd>True</dd>")
  end
  
  def test_presenting_a_time
    assert_equal 'Fri, 13 Feb 2009 02:31:00 +0000', present(Time.parse('02/13/2009 02:31 AM UTC').to_time)
  end
  
  def test_presenting_a_date
    assert_equal '2009-02-13', present(Time.parse('02/13/2009 02:31 AM').to_date)
  end
  
  def test_presenting_a_string
    assert_equal "hello world", present("hello world")
  end
  
  def test_presenting_a_named_method
    assert_equal "<span>hello world</span>", present('hello world', :in_a_span)
  end

  def test_presenting_a_symbol
    assert_equal "<span></span>", present(:in_a_span)
  end

  def test_presenting_a_named_presentation
    self.expects(:controller).returns(ActionView::TestCase::TestController.new)
    Presentation::Grid.any_instance.expects(:render)
    present('hello', :grid)
  end
  
  def test_presenting_an_unknown_presentation
    assert_raises ArgumentError do
      present(@users, :unknown)
    end
  end
  
  protected
  
  def present_in_a_span(str, options = {})
    "<span>#{str}</span>"
  end
end
