require File.dirname(__FILE__) + '/test_helper'

class FieldSearchTest < Presenting::Test
  def setup
    @s = Presentation::FieldSearch.new
  end

  def test_adding_a_field_by_name
    @s.fields = [:foo]
    assert_equal "Foo", @s.fields.first.name
    assert_equal :text, @s.fields.first.type
  end

  def test_adding_a_field_by_name_and_type
    @s.fields = [{"foo" => :bar}]
    assert_equal "foo", @s.fields.first.name
    assert_equal :bar, @s.fields.first.type
  end

  def test_adding_a_field_by_name_and_options
    @s.fields = [{"foo" => {:type => :bar}}]
    assert_equal "foo", @s.fields.first.name
    assert_equal :bar, @s.fields.first.type
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
    @presentation.controller.request.path = '/users'
  end

  def test_rendering_a_form_reuses_current_path
    assert_select 'form[action=/users?][method=get]'
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

  def test_rendering_a_dropdown_field_with_existing_value
    @presentation.fields << {:foo => {:type => :dropdown, :options => [["Dollar", "$"], ["Kroner", "DKK"]]}}
    @presentation.controller.params[:search] = {'foo' => {:value => 'DKK'}}

    assert_select "form select[name='search[foo][value]']" do
      assert_select "option[value='$']"
      assert_select "option[value='$'][selected='selected']", false
      assert_select "option[value='DKK'][selected='selected']"
    end
  end

  def test_rendering_a_dropdown_field_with_integers_and_existing_value
    @presentation.fields << {:foo => {:type => :dropdown, :options => [["Dollar", 1], ["Kroner", 2]]}}
    @presentation.controller.params[:search] = {'foo' => {:value => '2'}}

    assert_select "form select[name='search[foo][value]']" do
      assert_select "option[value='1']"
      assert_select "option[value='1'][selected='selected']", false
      assert_select "option[value='2'][selected='selected']"
    end
  end
end
