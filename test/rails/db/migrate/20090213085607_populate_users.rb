class PopulateUsers < ActiveRecord::Migration
  def self.up
    User.create(:prefix => 'Mr', :first_name => 'Samuel', :last_name => 'Flippledot', :email => "sam@example.com")
    User.create(:prefix => 'Mrs', :first_name => 'Jacey', :last_name => 'Flippledot', :email => "jacey@example.com")
    User.create(:prefix => 'Sr', :first_name => 'Chavez', :last_name => 'Laventin', :email => 'chavez@example.com')
    User.create(:prefix => 'Mr', :first_name => 'Cain', :last_name => 'Levy', :email => 'cain@example.com')
    User.create(:prefix => 'Ms', :first_name => 'Iris', :last_name => 'Tank', :email => 'iris@example.com')
  end

  def self.down
    User.destroy_all
  end
end
