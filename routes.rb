# needs Rails 2.3 to work w/o destroying the main app's routes
ActionController::Routing::Routes.draw do |map|
  map.namespace(:presentation) do |presentation|
    presentation.resources :stylesheets, :only => [:show]
  end
end
