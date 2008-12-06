module Presenting
  module Configurable
    def initialize(options = {})
      options.each do |k, v|
        self.send("#{k}=", v)
      end
    end
  end
end
