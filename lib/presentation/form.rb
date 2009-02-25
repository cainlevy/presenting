module Presentation
  class Form < Base
    # TODO
    # - field type (select, text area, text, checkbox, recordselect, calendar, etc.)
    # - example / description / help text
    # - nested fields
    # - grouped fields
    def fields
      @fields ||= Presenting::FieldSet.new(Field, :name, :type)
    end
    def fields=(args)
      args.each do |field|
        fields << field
      end
    end
    
    def url
      @url ||= presentable
    end
    attr_writer :url
    
    def method
      @method ||= presentable.new_record? ? :post : :put
    end
    attr_writer :method

    class Field
      include Presenting::Configurable
      
      def label
        @label ||= name.to_s.titleize
      end
      attr_writer :label
      
      attr_accessor :name
      
      def type
        @type ||= :text
      end
      attr_writer :type
    end

    def iname; :form end

    delegate :request_forgery_protection_token, :allow_forgery_protection, :to => :controller
    def protect_against_forgery? #:nodoc:
      allow_forgery_protection && request_forgery_protection_token
    end
  end
end
