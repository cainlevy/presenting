ActionController::Routing::Routes.draw do |map|
  map.namespace(:presentation) do |presentation|
    presentation.stylesheet 'stylesheets/:id.css', :controller => 'assets', :action => 'stylesheet', :format => 'css'
    presentation.javascript 'javascript/:id.js', :controller => 'assets', :action => 'javascript', :format => 'js'
  end
end
