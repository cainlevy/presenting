require File.dirname(__FILE__) + '/test_helper'

class GridTest < Presenting::Test
  def setup
    @g = Presentation::Grid.new
  end
  
  def test_default_title
    @g.id = "something_or_other"
    assert_equal "Something Or Other", @g.title
  end

  def test_adding_a_field_by_name
    @g.fields = ["foo"]
    assert_equal "foo", @g.fields.first.name, "name is stringified"
    assert_equal "foo", @g.fields.first.value, "value is assumed to be a method"
  end
  
  def test_adding_a_field_by_name_and_value
    @g.fields = [{"foo" => :bar}]
    assert_equal "foo", @g.fields.first.name, "key is name"
    assert_equal :bar, @g.fields.first.value, "value is value"
  end
  
  def test_adding_a_field_by_name_and_options
    @g.fields = [{"foo" => {:value => :bar}}]
    assert_equal "foo", @g.fields.first.name, "key is name"
    assert_equal :bar, @g.fields.first.value, "value is found and saved"
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

  def test_adding_nil_record_links
    assert_nothing_raised do
      # this would happen if a link sometimes did not appear
      @g.record_links = [nil]
    end
    assert @g.record_links.empty?
  end
  
  def test_adding_record_links_as_strings
    assert_raises ArgumentError do
      @g.record_links = ['<a href="/foo">foo</a>']
    end
  end
  
  def test_arrays_will_not_paginate
    @g.presentable = []
    assert !@g.paginate?
  end
  
  def test_paginated_collections_will_paginate
    @g.presentable = WillPaginate::Collection.new(1, 1)
    assert @g.paginate?
  end

  def test_unpaged_relations_will_not_paginate
    klass = Class.new(ActiveRecord::Base)
    table = Arel::Table.new('users')
    @g.presentable = ActiveRecord::Relation.new(klass, table)
    assert !@g.paginate?
  end

  def test_paginated_relations_will_paginate
    klass = Class.new(ActiveRecord::Base)
    table = Arel::Table.new('users')
    @g.presentable = ActiveRecord::Relation.new(klass, table).page(1)
    assert @g.paginate?
  end

end

class GridFieldTest < Presenting::Test
  def setup
    @f = Presentation::Grid::Field.new
  end
  
  def test_default_sorting_for_field
    @f.name = "First Name"
    assert @f.sortable?
    assert_equal "first_name", @f.sort_name
  end
  
  def test_sortable_field
    @f.name = "First Name"
    @f.sortable = true
    assert @f.sortable?
    assert_equal "first_name", @f.sort_name
  end
  
  def test_specified_sort_name
    @f.name = "First Name"
    @f.sortable = "foo"
    assert @f.sortable?
    assert_equal "foo", @f.sort_name
  end
  
  def test_unsortable_field
    @f.sortable = false
    assert !@f.sortable?
  end
end

class GridRenderTest < Presentation::RenderTest
  def setup
    Rails.application.routes.draw do resources :users end
    @presentation = Presentation::Grid.new(:id => "users", :fields => [:name, :email])
    @records = [
      stub('user', :name => 'foo', :email => 'foo@example.com'),
      stub('user', :name => 'bar', :email => 'bar@example.com')
    ]
    @presentation.presentable = @records
    @presentation.controller = ActionView::TestCase::TestController.new
    @presentation.controller.params = {:controller => 'users', :action => 'index'} # WillPaginate reuses existing params
  end
  
  def teardown
    Rails.application.reload_routes!
  end

  def test_rendering_the_title
    assert_select "#users table caption", 'Users'
  end
  
  def test_rendering_links
    @presentation.links = ['<a href="/foo" class="foo">bar</a>'.html_safe]

    assert_select '#users caption ul.actions' do
      assert_select 'li a.foo', 'bar'
    end
  end
  
  def test_rendering_record_links
    @presentation.record_links = [proc{|r| "<a href='/foo' class='record-link'>#{r.name}</a>".html_safe}]

    assert_select '#users tbody tr td ul.actions' do
      assert_select 'li a.record-link', 'foo'
      assert_select 'li a.record-link', 'bar'
    end
  end

  def test_rendering_column_headers
    assert_select "#users" do
      assert_select "thead" do
        assert_select "th.name", "Name"
        assert_select "th.email", "Email"
      end
    end
  end

  def test_rendering_rows
    assert_select "#users tbody" do
      assert_select "tr:nth-child(1)" do
        assert_select 'td.name', 'foo'
        assert_select 'td.email', 'foo@example.com'
      end
      assert_select "tr:nth-child(2)" do
        assert_select 'td.name', 'bar'
        assert_select 'td.email', 'bar@example.com'
      end
    end
  end
  
  def test_rendering_no_rows
    @presentation.presentable = []
    assert_select "#users tbody" do
      assert_select "tr", 1
      assert_select "tr td", "No records found."
    end
  end

  def test_rendering_sanitized_data
    @presentation.fields['Name'].sanitize = true
    @presentation.fields['Email'].sanitize = false
    @records << stub('row', :name => '&', :email => '&')
    
    assert_select "#users tbody tr" do
      assert_select 'td.name', '&amp;'
      assert_select 'td.email', '&'
    end
  end
  
  def test_rendering_sanitized_arrays
    @records << stub('row', :name => ['bob', '&', 'lucy'], :email => '')
    
    assert_select "#users tbody tr" do
      assert_select 'td.name' do
        assert_select 'ol li:nth-child(2)', '&amp;'
      end
    end
  end
  
  def test_rendering_with_pagination
    @presentation.presentable = WillPaginate::Collection.new(1, 1, 2)
    assert_select '#users tfoot .pagination'
  end
  
  def test_rendering_sortable_columns
    @presentation.fields.each{|f| f.sortable = true}
    
    assert_select "#users thead" do
      assert_select "th a.sortable", "Name"
      assert_select "th a.sortable", "Email"
    end
  end
  
  def test_rendering_unsortable_columns
    @presentation.fields.each{|f| f.sortable = false}
    
    assert_select "#users thead" do
      assert_select "th", "Name"
      assert_select "th", "Email"
    end
  end
  
  def test_rendering_a_sorted_column
    @presentation.fields.each{|f| f.sortable = true}
    @presentation.controller.request.env['QUERY_STRING'] = 'sort[name]=desc'

    assert_select "#users thead" do
      assert_select "th a.sortable[href='?sort[name]=asc']", "Name"
    end
  end
end

