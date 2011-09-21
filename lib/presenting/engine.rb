module Presenting
  class Engine < Rails::Engine
    initializer "presenting.precache" do |app|
      Presenting.precache!
    end
  end
end
