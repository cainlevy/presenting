require File.dirname(__FILE__) + '/test_helper'

class FieldSetTest < Presenting::Test
  def setup
    @set = Presenting::FieldSet.new(Presenting::Attribute, :name, :value)
  end
  
  def test_reading_a_field_by_name
    @set << "foo"
    assert_equal "foo", @set["foo"].name
  end
  
  def test_pushing_a_field_by_name
    @set << "foo"
    assert_equal "foo", @set.first.name
  end
  
  def test_pushing_a_field_by_name_and_value
    @set << {"foo" => :bar}
    assert_equal "foo", @set.first.name
    assert_equal :bar, @set.first.value
  end
  
  def test_pushing_a_field_by_name_and_options
    @set << {"foo" => {:value => :bar}}
    assert_equal "foo", @set.first.name
    assert_equal :bar, @set.first.value
  end
  
  def test_adding_a_field_by_name
    @set["foo"] = nil
    assert_equal "foo", @set.first.name
  end
  
  def test_adding_a_field_by_name_and_value
    @set["foo"] = :bar
    assert_equal "foo", @set.first.name
    assert_equal :bar, @set.first.value
  end
  
  def test_adding_a_field_by_name_and_options
    @set["foo"] = {:value => :bar}
    assert_equal "foo", @set.first.name
    assert_equal :bar, @set.first.value
  end
end
