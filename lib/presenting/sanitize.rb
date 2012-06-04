module Presenting::Sanitize
  class << self
    include ERB::Util
    
    # escape but preserve Arrays and Hashes
    def h(val)
      case val
      when Array
        val.map{|i| h(i)}
        
      when Hash
        val.clone.each{|k, v| val[h(k)] = h(v)}
        
      else
        html_escape(val)
      end
    end
  end
end
