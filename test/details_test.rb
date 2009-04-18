require File.dirname(__FILE__) + '/test_helper'

class DetailsTest < Presenting::Test
  def setup
    @d = Presentation::Details.new
  end
  
  def test_adding_a_field_by_name
    @d.fields = ["foo"]
    assert_equal "foo", @d.fields.first.name, "name is stringified"
    assert_equal "foo", @d.fields.first.value, "value is assumed to be a method"
  end
  
  def test_adding_a_field_by_name_and_value
    @d.fields = [{"foo" => :bar}]
    assert_equal "foo", @d.fields.first.name, "key is name"
    assert_equal :bar, @d.fields.first.value, "value is value"
  end
  
  def test_adding_a_field_by_name_and_options
    @d.fields = [{"foo" => {:value => :bar}}]
    assert_equal "foo", @d.fields.first.name, "key is name"
    assert_equal :bar, @d.fields.first.value, "value is found and saved"
  end
end

class DetailsRenderTest < Presentation::RenderTest
  def setup
    @presentation = Presentation::Details.new
    @presentation.presentable = stub('user', :name => 'foo', :email => 'foo@example.com')
    @presentation.controller = TestController.new
  end
  
  def test_rendering_a_title
    @presentation.title = 'Hello World'
    
    assert_select '.presentation-details h3', 'Hello World'
  end
  
  def test_rendering_an_attribute
    @presentation.fields = [:email]
    
    assert_select '.presentation-details' do
      assert_select 'dl' do
        assert_select 'dt', 'Email'
        assert_select 'dd', 'foo@example.com'
      end
    end
  end
  
  def test_rendering_sanitized_data
    @presentation.fields = [
      {:email => {:sanitize => false}},
      {:name  => {:sanitize => true}}
    ]
    @presentation.presentable = stub('user', :name => '&', :email => '&')
    
    assert_select '.presentation-details' do
      assert_select 'dl' do
        assert_select 'dt:nth-of-type(1)', 'Email'
        assert_select 'dd:nth-of-type(1)', '&'
        
        assert_select 'dt:nth-of-type(2)', 'Name'
        assert_select 'dd:nth-of-type(2)', '&amp;'
      end
    end
  end
end
