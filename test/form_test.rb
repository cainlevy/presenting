require File.dirname(__FILE__) + '/test_helper'

class FormTest < Presenting::Test
  def setup
    @f = Presentation::Form.new
  end
  
  def test_method_for_new_record
    @f.presentable = stub('record', :new_record? => true)
    assert_equal :post, @f.method
  end
  
  def test_method_for_existing_record
    @f.presentable = stub('record', :new_record? => false)
    assert_equal :put, @f.method
  end
  
  def test_adding_a_field_by_name
    @f.fields = [:a]
    
    assert_equal :a, @f.fields[0].name
    assert_equal 'A', @f.fields[0].label
    assert_equal :text, @f.fields[0].type
  end
  
  def test_adding_a_field_by_name_and_type
    @f.fields = [{:b => :boolean}]
    
    assert_equal :b, @f.fields[0].name
    assert_equal 'B', @f.fields[0].label
    assert_equal :boolean, @f.fields[0].type
  end
  
  def test_adding_a_field_by_name_and_options
    @f.fields = [{:foo => {:label => "Foo Bar", :type => :select}}]

    assert_equal :foo, @f.fields[0].name
    assert_equal 'Foo Bar', @f.fields[0].label
    assert_equal :select, @f.fields[0].type
  end
end

class FormRenderingTest < Presentation::RenderTest
  def setup
    @presentation = Presentation::Form.new
    @presentation.controller = TestController.new
  end
  
  def test_rendering_text_fields
    @presentation.presentable = User.new(:name => 'bob smith')
    @presentation.fields = [:name]

    assert_select 'form fieldset' do
      assert_select 'label', 'Name'
      assert_select "input[type=text][name='user[name]'][value='bob smith']"
    end
  end
  
  class User
    include Presenting::Configurable
    
    def new_record=(val)
      @new_record = val
    end
    
    def new_record?
      !! @new_record
    end
    
    attr_accessor :name
    
    def id
      @id ||= new_record? ? nil : '12345'
    end
    
    def to_param
      id
    end
    
    def self.name; 'User' end
  end
end
