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
