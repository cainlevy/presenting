module Presenting::Sanitize
  class << self
    include ERB::Util
    alias_method :h, :html_escape
  end
end
