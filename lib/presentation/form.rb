module Presentation
  class Form < Base
    # TODO
    # - field type (select, checkbox, recordselect, calendar, text area, etc.)
    # - label
    # - example / description / help text
    # - nested fields
    # - grouped fields
    def fields
      @fields ||= []
    end
    def fields=(val)
      @fields = val
    end
    
    def url
      @url ||= presentable
    end
    attr_writer :url
    
    def method
      @method ||= presentable.new_record? ? :post : :put
    end
    attr_writer :method

    def iname; :form end

    delegate :request_forgery_protection_token, :allow_forgery_protection, :to => :controller
    def protect_against_forgery? #:nodoc:
      allow_forgery_protection && request_forgery_protection_token
    end
  end
end
