Rails.application.routes.draw do
  namespace :presentation do
    controller 'assets' do
      match 'stylesheets/:id.:format', :as => 'stylesheet', :action => 'stylesheet', :via => [:get], :constraints => {:format => 'css'}
      match 'javascript/:id.:format', :as => 'javascript', :action => 'javascript', :via => [:get], :constraints => {:format => 'js'}
    end
  end
end
