module Presentation
  class Form < Base
    # TODO
    # field type              extra details?
    # * text
    # * text_area
    # * password
    # * check_box             checked/unchecked values
    # * radio (= dropdown)    options
    # * dropdown (= radio)    options
    # * multi-select          options
    # * recordselect          url?
    # * calendar              constraints
    # * time                  constraints
    # * date
    # * datetime
    #
    # other
    # - example / description / help text
    # - nested fields
    
    # Fields may be grouped. Groups may or may not have names. Here's how:
    #
    #   Presentation::Form.new(:groups => [
    #     [:a, :b],             # creates a nameless group with fields :a and :b
    #     {"foo" => [:c, :d]}   # creates a group named "foo" with fields :c and :d
    #   ])
    #
    # Note that if you don't need groups it'll be simpler to just use fields= instead.
    def groups
      @groups ||= GroupSet.new
    end
    def groups=(args)
      args.each do |group|
        groups << group
      end
    end

    class GroupSet < Array
      def <<(val)
        if val.is_a? Hash
          opts = {:name => val.keys.first, :fields => val.values.first}
        else
          opts = {:fields => val}
        end
        super Group.new(opts)
      end
    end
    
    class Group
      include Presenting::Configurable
      
      # a completely optional group name
      attr_accessor :name
      
      # the fields in the group
      def fields
        @fields ||= Presenting::FieldSet.new(Field, :name, :type)
      end
      def fields=(args)
        args.each do |field|
          fields << field
        end
      end
    end

    # Used to define fields in a group-less form.
    def fields
      if groups.empty?
        groups << []
      end
      groups.first.fields
    end
    def fields=(args)
      args.each do |field|
        fields << field
      end
    end
    
    # The url where the form posts. May be anything that url_for accepts, including
    # a set of records.
    def url
      @url ||= presentable
    end
    attr_writer :url
    
    # What method the form should use to post. Should default intelligently enough from
    # the presentable. Not sure what use case would require it being set manually.
    def method
      @method ||= presentable.new_record? ? :post : :put
    end
    attr_writer :method

    class Field
      include Presenting::Configurable
      
      # the display label of the field
      def label
        @label ||= name.to_s.titleize
      end
      attr_writer :label
      
      # the parameter (and method) name of the field
      attr_accessor :name
      
      # the widget type for the field. use type_options to pass arguments to the widget.
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
