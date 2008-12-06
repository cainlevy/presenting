ActionController::Base.view_paths << File.join(File.dirname(__FILE__), 'app', 'views')
ActionView::Base.class_eval { include Presenting::Helpers }
