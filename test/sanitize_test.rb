require File.dirname(__FILE__) + '/test_helper'

class Presenting::SanitizeTest < Presenting::Test
  def test_sanitizing_an_array
    assert_equal ['&amp;'], Presenting::Sanitize.h(['&'])
  end
  
  def test_sanitizing_a_hash
    assert_equal({'<' => '>'}, Presenting::Sanitize.h({'<' => '>'}))
  end
  
  def test_sanitizing_a_string
    assert_equal '&amp;', Presenting::Sanitize.h('&')
  end
end
