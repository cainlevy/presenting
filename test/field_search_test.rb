require File.dirname(__FILE__) + '/test_helper'

class FieldSearchTest < Presenting::Test
  def setup
    @s = Presentation::FieldSearch.new
  end

  def test_adding_complex_field_setup
    @s.fields = [
      :a,
      {:b => :boolean},
      {"Foo Bar" => {:type => :time}}
    ]
    
    assert_equal 3, @s.fields.size

    assert_equal 'A', @s.fields[0].name
    assert_equal 'a', @s.fields[0].param
    assert_equal :text, @s.fields[0].type
    
    assert_equal 'B', @s.fields[1].name
    assert_equal 'b', @s.fields[1].param
    assert_equal :boolean, @s.fields[1].type
    
    assert_equal 'Foo Bar', @s.fields[2].name
    assert_equal 'foo_bar', @s.fields[2].param
    assert_equal :time, @s.fields[2].type
  end
end

class FieldSearchFieldSetTest < Presenting::Test

  def setup
    @f = Presentation::FieldSearch::FieldSet.new
  end

  def test_adding_a_field_by_name
    @f << :foo
    assert_equal "Foo", @f.first.name
    assert_equal :text, @f.first.type
  end
  
  def test_adding_a_field_by_name_and_type
    @f << {"foo" => :bar}
    assert_equal "foo", @f.first.name
    assert_equal :bar, @f.first.type
  end
  
  def test_adding_a_field_by_name_and_options
    @f << {"foo" => {:type => :bar}}
    assert_equal "foo", @f.first.name
    assert_equal :bar, @f.first.type
  end
end

class FieldSearchFieldTest < Presenting::Test
  def setup
    @f = Presentation::FieldSearch::Field.new
  end
  
  def test_assigning_a_symbol_name
    @f.name = :foo
    assert_equal "Foo", @f.name, "name is typecast to a string and titleized"
  end
  
  def test_assigning_a_string_name
    @f.name = "foo"
    assert_equal "foo", @f.name, "name remains a string"
  end
  
  def test_default_type
    assert_equal :text, @f.type
  end
end

class FieldSearchRenderingTest < Presentation::RenderTest
  def setup
    @presentation = Presentation::FieldSearch.new
    @presentation.controller = TestController.new
    @presentation.controller.params = {:controller => 'users', :action => 'index'} # search reuses existing params
  end
  
  def test_rendering_a_form_reuses_existing_action
    assert_select 'form[action=/users][method=get]'
  end
  
  def test_rendering_a_text_field
    @presentation.fields << {:foo => :text}
    assert_select "form input[type=text][name='search[foo][value]']"
  end
  
  def test_rendering_a_text_field_with_existing_value
    @presentation.fields << {:foo => :text}
    @presentation.controller.params[:search] = {'foo' => {:value => 'bar'}}
    assert_select "form input[type=text][name='search[foo][value]'][value=bar]"
  end
  
  def test_rendering_a_checkbox_field
    @presentation.fields << {:foo => :checkbox}
    assert_select "form input[type=checkbox][name='search[foo][value]'][value=1]"
  end
  
  def test_rendering_a_checkbox_field_with_existing_value
    @presentation.fields << {:foo => :checkbox}
    @presentation.controller.params[:search] = {'foo' => {:value => '1'}}

    assert_select "form input[type=checkbox][name='search[foo][value]'][value=1][checked=checked]"
  end
end
