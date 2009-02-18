require File.dirname(__FILE__) + '/test_helper'

class GridTest < Test::Unit::TestCase

  def setup
    @g = Presentation::Grid.new
  end
  
  def test_default_title
    @g.id = "something_or_other"
    assert_equal "Something Or Other", @g.title
  end

  def test_adding_multiple_fields
    @g.fields = [
      :a,
      {:b => "foo"},
      {:c => {:value => "bar"}}
    ]
    assert_equal 3, @g.fields.size, "all fields are saved"
    
    assert_equal "A", @g.fields[0].name
    assert_equal :a, @g.fields[0].value
    
    assert_equal "B", @g.fields[1].name
    assert_equal "foo", @g.fields[1].value
    
    assert_equal "C", @g.fields[2].name
    assert_equal "bar", @g.fields[2].value
  end

  def test_render
    @g = Presentation::Grid.new(:id => "foo")
    @g.presentable = []
    @render = @g.render
    assert_select "#foo" do
      assert_select "div.title", "Foo"
    end
  end
  
  def test_rendering_column_headers
    @g = Presentation::Grid.new(:id => "foo", :fields => [:a, :b, :c])
    @g.presentable = []
    @render = @g.render
    assert_select "#foo" do
      assert_select "thead" do
        assert_select "th", "A"
        assert_select "th", "B"
        assert_select "th", "C"
      end
    end
  end

  def test_rendering_rows
    @g = Presentation::Grid.new(:id => "foo", :fields => [:a, :b])
    @g.presentable = [
      mock('row', :a => "alpha", :b => "beta"),
      mock('row', :a => "alpha2", :b => "beta2")
    ]
    @render = @g.render
    assert_select "#foo tbody" do
      assert_select "tr:nth-child(1)" do
        assert_select 'td:nth-child(1)', 'alpha'
        assert_select 'td:nth-child(2)', 'beta'
      end
      assert_select "tr:nth-child(2)" do
        assert_select 'td:nth-child(1)', 'alpha2'
        assert_select 'td:nth-child(2)', 'beta2'
      end
    end
  end

end

class GriedFieldSetTest < Test::Unit::TestCase

  def setup
    @f = Presentation::Grid::FieldSet.new
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
    @f = Presentation::Grid::Field.new
  end

  def test_assigning_a_symbol_name
    @f.name = :foo
    assert_equal "Foo", @f.name, "name is typecast to a string and titleized"
    assert_equal :foo, @f.value, "value is assumed to be a symbol as well"
  end
  
  def test_assigning_a_string_name
    @f.name = "foo"
    assert_equal "foo", @f.name, "name remains a string"
    assert_equal "foo", @f.value, "value is assumed to be a string"
  end
  
  def test_symbol_values
    @f.value = :foo
    assert_equal "bar", @f.value_from(stub('row', :foo => "bar")), "symbols are methods"
  end
  
  def test_string_values
    @f.value = "foo"
    assert_equal "foo", @f.value_from(stub('row', :foo => "bar")), "strings are constant"
  end
  
  def test_proc_values
    @f.value = proc{|row| "hello"}
    assert_equal "hello", @f.value_from(stub('row', :foo => "bar")), "procs are custom"
  end
  
end

