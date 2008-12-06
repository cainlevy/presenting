# add ourselves to the view paths
ActionController::Base.view_paths << File.join(File.dirname(__FILE__), 'app', 'views')

# trigger autoload
Presenting
