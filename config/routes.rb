ActionController::Routing::Routes.draw do |map|
  map.namespace(:presentation) do |presentation|
    presentation.resources :stylesheets, :only => [:show]
  end
end
