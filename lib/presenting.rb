require 'action_view'
require 'action_controller'

module Presenting
  autoload :Attribute, 'presenting/attribute'
  autoload :Configurable, 'presenting/configurable'
  autoload :Defaults, 'presenting/defaults'
  autoload :FieldSet, 'presenting/field_set'
  autoload :FormHelpers, 'presenting/form_helpers'
  autoload :Helpers, 'presenting/helpers'
  autoload :Sanitize, 'presenting/sanitize'
  autoload :Search, 'presenting/search'
  autoload :Sorting, 'presenting/sorting'
  autoload :View, 'presenting/view'
end

module Presentation
  autoload :Base, 'presentation/base'
end

Dir[File.join(File.dirname(__FILE__), 'presentation', '*')].each { |path| require path }

ActionView::Base.class_eval { include Presenting::Helpers }
ActionController::Base.const_set(:Search, Presenting::Search)
ActionController::Base.const_set(:Sorting, Presenting::Sorting)
ActionView::Helpers::FormBuilder.class_eval { include Presenting::FormHelpers }
