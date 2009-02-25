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
  
  def test_button_for_new_record
    @f.presentable = stub('record', :new_record? => true)
    assert_equal 'Create', @f.button
  end
  
  def test_button_for_existing_record
    @f.presentable = stub('record', :new_record? => false)
    assert_equal 'Update', @f.button
  end
  
  def test_adding_a_field_by_name
    @f.fields = [:a]
    
    assert_equal :a, @f.fields[0].name
    assert_equal 'A', @f.fields[0].label
    assert_equal :string, @f.fields[0].type
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
  
  def test_fields_accessors_are_shortcuts_to_first_group
    @f.fields = [:a]
    assert_equal :a, @f.groups.first.fields.first.name
    assert_equal @f.fields, @f.groups.first.fields
  end
  
  def test_adding_an_unnamed_group_of_fields
    @f.groups = [[:a]]
    
    assert_nil @f.groups[0].name
    assert_equal :a, @f.groups[0].fields[0].name
  end
  
  def test_adding_a_named_group_of_fields
    @f.groups = [{"foo" => [:a]}]
    
    assert_equal "foo", @f.groups[0].name
    assert_equal :a, @f.groups[0].fields[0].name
  end
end

class FormRenderingTest < Presentation::RenderTest
  def setup
    @presentation = Presentation::Form.new
    @presentation.controller = TestController.new
  end
  
  def test_rendering_a_string_field
    @presentation.presentable = User.new(:name => 'bob smith')
    @presentation.fields = [:name]

    assert_select 'form div.field' do
      assert_select 'label', 'Name'
      assert_select "input[type=text][name='user[name]'][value='bob smith']"
    end
  end
  
  def test_rendering_a_text_field
    @presentation.presentable = User.new(:name => 'bob smith')
    @presentation.fields = [{:name => :text}]
    
    assert_select 'form div.field' do
      assert_select 'label', 'Name'
      assert_select "textarea[name='user[name]']", 'bob smith'
    end
  end
  
  def test_rendering_a_password_field
    @presentation.presentable = User.new(:name => 'bob smith')
    @presentation.fields = [{:name => :password}]
    
    assert_select 'form div.field' do
      assert_select 'label', 'Name'
      assert_select "input[type=password][name='user[name]'][value='bob smith']"
    end
  end
  
  def test_rendering_a_boolean_field
    @presentation.presentable = User.new(:suspended => false, :registered => true)
    @presentation.fields = [{:suspended => :boolean}, {:registered => :boolean}]

    assert_select 'form div.field:nth-of-type(1)' do
      assert_select 'label', 'Suspended'
      assert_select "input[type=checkbox][name='user[suspended]']"
    end
    assert_select 'form div.field:nth-of-type(2)' do
      assert_select 'label', 'Registered'
      assert_select "input[type=checkbox][name='user[registered]'][checked=checked]"
    end
  end
  
  def test_rendering_a_dropdown_field
    @presentation.presentable = User.new(:prefix => 'mr')
    @presentation.fields = [{:prefix => {:type => :dropdown, :type_options => [['Mr.', 'mr'], ['Mrs.', 'mrs']]}}]
    
    assert_select 'form div.field' do
      assert_select 'label', 'Prefix'
      assert_select "select[name='user[prefix]']" do
        assert_select "option[value=mr][selected=selected]", "Mr."
        assert_select "option[value=mrs]", "Mrs."
      end
    end
  end

  def test_rendering_a_radios_field
    @presentation.presentable = User.new(:prefix => 'mr')
    @presentation.fields = [{:prefix => {:type => :radios, :type_options => [['Mr.', 'mr'], ['Mrs.', 'mrs']]}}]
    
    assert_select 'form div.field' do
      assert_select 'label', 'Prefix'
      assert_select "label[for=user_prefix_mr]", "Mr."
      assert_select "input[type=radio][name='user[prefix]'][value=mr][checked=checked]"
      assert_select "label[for=user_prefix_mrs]", "Mrs."
      assert_select "input[type=radio][name='user[prefix]'][value=mrs]"
    end
  end

  def test_rendering_a_multi_select_field
    @presentation.presentable = User.new(:role_ids => [1,3])
    @presentation.fields = [{:role_ids => {:type => :multi_select, :type_options => [['A', 1], ['B', 2], ['C', 3]], :label => "Roles"}}]
    
    assert_select 'form div.field' do
      assert_select 'label', 'Roles'
      assert_select "select[name='user[role_ids][]'][multiple=multiple]" do
        assert_select "option[value=1][selected=selected]", "A"
        assert_select "option[value=2]", "B"
        assert_select "option[value=3][selected=selected]", "C"
      end
    end
  end
  
  def test_rendering_a_group_of_fields
    @presentation.presentable = User.new
    @presentation.groups = [
      [:name, :email],
      {"flags" => [:registered, :suspended]}
    ]

    assert_select "form fieldset:nth-of-type(1)" do
      assert_select "legend", false
      assert_select "div.field input[name='user[name]']"
      assert_select "div.field input[name='user[email]']"
    end
    assert_select "form fieldset:nth-of-type(2)" do
      assert_select "legend", "flags"
      assert_select "div.field input[name='user[registered]']"
      assert_select "div.field input[name='user[suspended]']"
    end
  end
  
  class User
    include Presenting::Configurable
    
    attr_accessor :prefix
    attr_accessor :name
    attr_accessor :email
    attr_accessor :registered
    attr_accessor :suspended
    attr_accessor :role_ids
    
    ##
    ## duck typing
    ##
    
    def new_record=(val)
      @new_record = val
    end
    
    def new_record?
      !! @new_record
    end

    def id
      @id ||= new_record? ? nil : '12345'
    end
    
    def to_param
      id
    end
    
    def self.name; 'User' end
  end
end
