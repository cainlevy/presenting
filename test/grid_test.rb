require File.dirname(__FILE__) + '/test_helper'

class GridTest < Presentation::Test
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
  
  def test_adding_links_as_strings
    @g.links = ['<a href="/foo">foo</a>']
    assert_equal 1, @g.links.size
  end
  
  def test_adding_links_as_procs
    assert_raises ArgumentError do
      @g.links = [proc{|record| link_to(record.name, record)}]
    end
  end
  
  def test_adding_record_links_as_procs
    @g.record_links = [proc{|record| link_to(record.name, record)}]
    assert_equal 1, @g.record_links.size
  end
  
  def test_adding_record_links_as_strings
    assert_raises ArgumentError do
      @g.record_links = ['<a href="/foo">foo</a>']
    end
  end
  
  def test_arrays_do_not_paginate
    @g.presentable = []
    assert !@g.paginate?
  end
  
  def test_paginated_collections_will_paginate
    @g.presentable = WillPaginate::Collection.new(1, 1)
    assert @g.paginate?
  end
end

class GridRenderTest < Presentation::RenderTest
  def setup
    @presentation = Presentation::Grid.new(:id => "users", :fields => [:name, :email])
    @records = [
      stub('user', :name => 'foo', :email => 'foo@example.com'),
      stub('user', :name => 'bar', :email => 'bar@example.com')
    ]
    @presentation.presentable = @records
    @presentation.controller = TestController.new
    @presentation.controller.params = {:controller => 'users', :action => 'index'} # WillPaginate reuses existing params
  end

  def test_rendering_the_title
    assert_select "#users table caption", 'Users'
  end
  
  def test_rendering_links
    @presentation.links = ['<a href="/foo" class="foo">bar</a>']

    assert_select '#users caption ul.actions' do
      assert_select 'li a.foo', 'bar'
    end
  end
  
  def test_rendering_record_links
    @presentation.record_links = [proc{|r| "<a href='/foo' class='record-link'>#{r.name}</a>"}]
    
    assert_select '#users tbody tr td ul.actions' do
      assert_select 'li a.record-link', 'foo'
      assert_select 'li a.record-link', 'bar'
    end
  end

  def test_rendering_column_headers
    assert_select "#users" do
      assert_select "thead" do
        assert_select "th", "Name"
        assert_select "th", "Email"
      end
    end
  end

  def test_rendering_rows
    assert_select "#users tbody" do
      assert_select "tr:nth-child(1)" do
        assert_select 'td:nth-child(1)', 'foo'
        assert_select 'td:nth-child(2)', 'foo@example.com'
      end
      assert_select "tr:nth-child(2)" do
        assert_select 'td:nth-child(1)', 'bar'
        assert_select 'td:nth-child(2)', 'bar@example.com'
      end
    end
  end

  def test_rendering_sanitized_data
    @presentation.fields[0].sanitize = true
    @presentation.fields[1].sanitize = false
    @records << stub('row', :name => '&', :email => '&')
    
    assert_select "#users tbody tr" do
      assert_select 'td:nth-child(1)', '&amp;'
      assert_select 'td:nth-child(2)', '&'
    end
  end
  
  def test_rendering_with_pagination
    @presentation.presentable = WillPaginate::Collection.new(1, 1, 2)
    assert_select '#users tfoot .pagination'
  end
end

class GridFieldSetTest < Presentation::Test

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

class GridFieldTest < Presentation::Test

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
  
  def test_that_value_from_sanitizes_when_configured
    @f.value = '<span>hello</span>'
    @f.sanitize = true
    assert_equal '&lt;span&gt;hello&lt;/span&gt;', @f.value_from(nil)
  end
  
  def test_sanitize_is_default_true
    assert @f.sanitize?
  end
end

