module Presenting
  module Configurable
    def initialize(options = {}, &block)
      options.each do |k, v|
        self.send("#{k}=", v)
      end
      yield self if block_given?
    end
  end
end
