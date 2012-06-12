require 'action_view'
require 'action_controller'
require 'presenting/engine'

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

  # copies all assets into the application's public directory
  # public/stylesheets/presenting and public/javascripts/presenting
  def self.precache!
    presenting_dir = File.join(File.dirname(__FILE__), '../') # gross
    %w(stylesheets javascripts).each do |asset_type|
      source_dir = File.join(presenting_dir, 'app', 'assets', asset_type)
      target_dir = File.join(Rails.application.paths["public/#{asset_type}"].first, 'presenting')
      FileUtils.mkdir_p(target_dir)

      Dir[File.join(source_dir, '*')].each do |asset|
        FileUtils.cp(asset, File.join(target_dir, File.basename(asset)))
      end
    end
  end
end

module Presentation
  autoload :Base, 'presentation/base'
end

Dir[File.join(File.dirname(__FILE__), 'presentation', '*')].each { |path| require path }

ActionView::Base.class_eval { include Presenting::Helpers }
ActionController::Base.const_set(:Search, Presenting::Search)
ActionController::Base.const_set(:Sorting, Presenting::Sorting)
ActionView::Helpers::FormBuilder.class_eval { include Presenting::FormHelpers }
