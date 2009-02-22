module Presenting
  # prior to Rails 2.3, you need to call this manually from your config/routes.rb
  def self.draw_routes(map)
    map.namespace(:presentation) do |presentation|
      presentation.stylesheet 'stylesheets/:id.css', :controller => 'assets', :action => 'stylesheet', :format => 'css'
      presentation.javascript 'javascript/:id.js', :controller => 'assets', :action => 'javascript', :format => 'js'
    end
  end
end
