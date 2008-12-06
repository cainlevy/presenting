require File.dirname(__FILE__) + '/test_helper'

class GridTest < Test::Unit::TestCase

  def setup
    @g = Presenting::Grid.new
  end

  def test_adding_multiple_fields
    @g.fields = [
      :a,
      {:b => "foo"},
      {:c => {:value => "bar"}}
    ]
    assert_equal 3, @g.fields.size, "all fields are saved"
    
    assert_equal "a", @g.fields[0].name
    assert_equal :a, @g.fields[0].value
    
    assert_equal "b", @g.fields[1].name
    assert_equal "foo", @g.fields[1].value
    
    assert_equal "c", @g.fields[2].name
    assert_equal "bar", @g.fields[2].value
  end

end

class GriedFieldSetTest < Test::Unit::TestCase

  def setup
    @f = Presenting::Grid::FieldSet.new
  end

  def test_adding_a_field_by_name
    @f << "foo"
    assert_equal "foo", @f.first.name, "name is stringified"
    assert_equal "foo", @f.first.value, "value is assumed to be a method"
  end
  
  def test_adding_a_field_by_name_and_value
    @f << {"foo" => :bar}
    assert_equal "foo", @f.first.name, "key is name"
    assert_equal :bar, @f.first.value, "value is value"
  end
  
  def test_adding_a_field_by_name_and_options
    @f << {"foo" => {:value => :bar}}
    assert_equal "foo", @f.first.name, "key is name"
    assert_equal :bar, @f.first.value, "value is found and saved"
  end

end

class GridFieldTest < Test::Unit::TestCase

  def setup
    @f = Presenting::Grid::Field.new
  end

  def test_assigning_a_symbol_name
    @f.name = :foo
    assert_equal "foo", @f.name, "name is typecast to a string"
    assert_equal :foo, @f.value, "value is assumed to be a symbol as well"
  end
  
  def test_assigning_a_string_name
    @f.name = "foo"
    assert_equal "foo", @f.name, "name remains a string"
    assert_equal "foo", @f.value, "value is assumed to be a constant string"
  end
  
end
