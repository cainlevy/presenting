require File.dirname(__FILE__) + '/test_helper'

class SortingTest < Presenting::Test
  def setup
    @s = Presenting::Sorting.new
  end
  
  def test_assigning_a_simple_set_of_fields
    @s.fields = [:a]
    assert_equal 1, @s.fields.size
    
    assert_equal 'a', @s.fields[0].name
    assert_equal 'a', @s.fields[0].sql
  end
  
  def test_assigning_fields_with_custom_sql
    @s.fields = {:a => 'users.a'}
    assert_equal 1, @s.fields.size
    
    assert_equal 'a', @s.fields[0].name
    assert_equal 'users.a', @s.fields[0].sql
  end
  
  def test_assigning_default_sql
    @s.fields = {:a => 'users.a'}
    @s.default = [:a, 'desc']
    assert_equal "users.a DESC", @s.default
  end
  
  def test_the_default_default
    @s.fields = {:a => 'users.a'}
    assert_equal 'users.a ASC', @s.default
  end
  
  def test_generating_sorting_sql
    @s.fields = {:a => 'users.a', :b => 'users.b'}
    
    assert_equal 'users.a DESC', @s.to_sql({'a' => 'desc'})
  end
  
  def test_generating_sort_sql_with_no_known_fields
    @s.fields = {:a => 'users.a', :b => 'users.b'}
    @s.default = [:b, 'desc']
    
    assert_equal 'users.b DESC', @s.to_sql(nil)
  end
end

class SortingFieldTest < Presenting::Test
  def setup
    @f = Presenting::Sorting::Field.new
  end

  def test_assigning_a_symbol_name
    @f.name = :foo
    assert_equal 'foo', @f.name
  end
  
  def test_sql_defaults_to_name
    @f.name = :foo
    assert_equal 'foo', @f.sql
  end
end
