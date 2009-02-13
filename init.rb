ActionView::Base.class_eval { include Presenting::Helpers }

# should not be needed in Rails 2.3
ActionController::Base.view_paths << File.join(File.dirname(__FILE__), 'app', 'views')
ActiveSupport::Dependencies.load_paths << File.dirname(__FILE__) + '/app/controllers'
$LOAD_PATH.unshift File.dirname(__FILE__) + '/app/controllers/'
require 'routes'
