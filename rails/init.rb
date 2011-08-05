ActionView::Base.class_eval { include Presenting::Helpers }
ActionController::Base.const_set(:Search, Presenting::Search)
ActionController::Base.const_set(:Sorting, Presenting::Sorting)
ActionView::Helpers::FormBuilder.class_eval { include Presenting::FormHelpers }

if defined? Rails # because tests don't define the Rails module
  if Rails.version.match(/^2\.2/)
    ActionController::Base.view_paths << File.join(File.dirname(__FILE__), 'app', 'views')
    ActiveSupport::Dependencies.load_paths << File.dirname(__FILE__) + '/app/controllers'
    $LOAD_PATH.unshift File.dirname(__FILE__) + '/app/controllers/'
  end
end
