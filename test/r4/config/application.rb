require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env) if defined?(Bundler)

module R4
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
  	config.secret_key_base = "blahblahblahblah"
  end
end
