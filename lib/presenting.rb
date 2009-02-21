module Presenting
  # prior to Rails 2.3, you need to call this manually from your config/routes.rb
  def self.draw_routes(map)
    map.namespace(:presentation) do |presentation|
      presentation.stylesheet 'stylesheets/:id.:format', :controller => 'assets', :action => 'stylesheet'
      presentation.javascript 'javascript/:id.:format', :controller => 'assets', :action => 'javascript'
    end
  end
end
