require File.dirname(__FILE__) + '/test_helper'

class AttributeTest < Presenting::Test

  def setup
    @a = Presenting::Attribute.new
  end

  def test_assigning_a_symbol_name
    @a.name = :foo
    assert_equal "Foo", @a.name, "name is typecast to a string and titleized"
    assert_equal :foo, @a.value, "value is assumed to be a symbol as well"
  end
  
  def test_assigning_a_string_name
    @a.name = "foo"
    assert_equal "foo", @a.name, "name remains a string"
    assert_equal "foo", @a.value, "value is assumed to be a string"
  end
  
  def test_symbol_values
    @a.value = :foo
    assert_equal "bar", @a.value_from(stub('row', :foo => "bar")), "symbols are methods"
  end
  
  def test_string_values
    @a.value = "foo"
    assert_equal "foo", @a.value_from(stub('row', :foo => "bar")), "strings are constant"
  end
  
  def test_proc_values
    @a.value = proc{|row| "hello"}
    assert_equal "hello", @a.value_from(stub('row', :foo => "bar")), "procs are custom"
  end
  
  def test_that_value_from_does_not_sanitizes_itself
    @a.value = '<span>hello</span>'
    @a.sanitize = true
    assert_equal '<span>hello</span>', @a.value_from(nil)
  end

  def test_sanitize_is_default_true
    assert @a.sanitize?
  end
  
  def test_assigning_a_symbol_id
    @a.id = :foo
    assert_equal 'foo', @a.id
  end
  
  def test_default_id_from_complex_name
    @a.name = 'Hello, World!'
    assert_equal 'hello_world', @a.id
  end
end

