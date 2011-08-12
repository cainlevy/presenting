Rails.application.routes.draw do
  namespace :presentation do
    controller 'assets' do
      match 'stylesheets/:id.:format', :as => 'stylesheet', :action => 'stylesheet', :constraints => {:format => 'css'}
      match 'javascript/:id.:format', :as => 'javascript', :action => 'javascript', :constraints => {:format => 'js'}
    end
  end
end
