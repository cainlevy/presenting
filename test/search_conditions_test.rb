require File.dirname(__FILE__) + '/test_helper'

class SearchConditionsTest < Presenting::Test
  def setup
    @c = Presenting::SearchConditions.new
  end
  
  def test_assigning_a_simple_set_of_fields
    @c.fields = [:a]
    assert_equal 1, @c.fields.size
    
    assert_equal 'a', @c.fields[0].name
    assert_equal 'a', @c.fields[0].sql
    assert_equal '= ?', @c.fields[0].operator
    assert_equal '?', @c.fields[0].bind_pattern
  end
  
  def test_assigning_fields_with_custom_patterns
    @c.fields = {:a => :begins_with}
    assert_equal 1, @c.fields.size
    
    assert_equal 'a', @c.fields[0].name
    assert_equal 'a', @c.fields[0].sql
    assert_equal 'LIKE ?', @c.fields[0].operator
    assert_equal '?%', @c.fields[0].bind_pattern
  end
  
  def test_assigning_fields_with_full_options
    @c.fields = {:a => {:sql => 'foo', :pattern => :begins_with}}
    assert_equal 1, @c.fields.size
    
    assert_equal 'a', @c.fields[0].name
    assert_equal 'foo', @c.fields[0].sql
    assert_equal 'LIKE ?', @c.fields[0].operator
    assert_equal '?%', @c.fields[0].bind_pattern
  end
  
  def test_conditions_with_no_term
    @c.fields = [:a, :b]
    assert_nil @c.to_conditions(nil)
    assert_nil @c.to_conditions('')
  end
  
  def test_simple_conditions
    @c.fields << :a
    @c.fields << {:b => :begins_with}
    assert_equal ["a = ? OR b LIKE ?", 'foo', 'foo%'], @c.to_conditions('foo', :simple)
  end
  
  def test_field_conditions
    @c.fields << :a
    @c.fields << {:b => :begins_with}
    assert_equal ["a = ? AND b LIKE ?", 'foo', 'bar%'], @c.to_conditions({'a' => {:value => 'foo'}, 'b' => {:value => 'bar'}}, :field)
  end
  
  def test_field_conditions_with_a_blank_term
    @c.fields = [:a, :b]
    assert_equal ["a = ?", 'foo'], @c.to_conditions({'a' => {:value => 'foo'}, 'b' => {:value => ''}}, :field)
  end
  
  def test_field_conditions_with_null_field
    @c.fields << :a
    @c.fields << {:b => :null}
    assert_equal ["a = ? AND b IS NULL", 'foo'], @c.to_conditions({'a' => {:value => 'foo'}, 'b' => {:value => '1'}}, :field)
  end
  
  def test_field_conditions_without_null_field
    @c.fields << :a
    @c.fields << {:b => :null}
    assert_equal ["a = ?", 'foo'], @c.to_conditions({'a' => {:value => 'foo'}}, :field)
  end
end

class SearchConditionsFieldTest < Presenting::Test
  def setup
    @f = Presenting::SearchConditions::Field.new
  end
  
  def test_assigning_a_symbol_name
    @f.name = :foo
    assert_equal 'foo', @f.name
  end
  
  def test_sql_defaults_to_name
    @f.name = :foo
    assert_equal 'foo', @f.sql
  end
  
  def test_default_operator
    assert_equal '= ?', @f.operator
  end
  
  def test_default_bind_pattern
    assert_equal '?', @f.bind_pattern
  end
  
  def test_fragment_joins_sql_and_operator
    @f.sql = 'foo'
    @f.operator = 'bar'
    assert_equal "foo bar", @f.fragment
  end
  
  def test_bind_returns_nil_if_operator_has_no_place
    @f.operator = 'is null'
    assert_equal nil, @f.bind('foo')
  end
  
  def test_bind_returns_term_applied_to_bind_pattern
    @f.bind_pattern = '%?%'
    assert_equal '%foo%', @f.bind('foo')
  end
end
