module Presenting
  class Engine < Rails::Engine
    initializer "presenting.precache" do |app|
      Presenting.precache! unless Rails.configuration.assets.enabled
    end
  end
end
