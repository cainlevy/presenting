require File.dirname(__FILE__) + '/test_helper'

class ConfigurableTest < Presenting::Test
  class ConfigurableUser
    include Presenting::Configurable
    attr_accessor :first_name
    attr_reader   :name
  end
  
  def test_setting_first_name_with_initializer
    user = ConfigurableUser.new(:first_name => "Bob")
    assert_equal 'Bob', user.first_name
  end
  
  def test_setting_unsettable_attribute
    assert_raises NoMethodError do
      ConfigurableUser.new(:name => 'Bob Jenkins')
    end
  end
end
