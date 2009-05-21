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

    # the text on the submit button
    def button
      @button ||= presentable.new_record? ? 'Create' : 'Update'
    end
    attr_writer :button
    
    # a passthrough for form_for's html. useful for classifying a form for ajax behavior (e.g. :html => {:class => 'ajax'})
    attr_accessor :html

    class Field
      include Presenting::Configurable
      
      # the display label of the field
      def label
        @label ||= name.to_s.titleize
      end
      attr_writer :label
      
      # the parameter name of the field
      attr_accessor :name

      # where the value for this field comes from.
      # - String: a fixed value
      # - Symbol: a method on the record (no arguments)
      # - Proc: a custom block that accepts the record as an argument
      def value
        @value ||= name.to_sym
      end
      attr_writer :value
      
      def value_from(obj) #:nodoc:
        v = case value
          when Symbol: obj.send(value)
          when String: value
          when Proc:   value.call(obj)
        end
      end
      
      # the widget type for the field. use type_options to pass arguments to the widget.
      def type
        @type ||= :string
      end
      attr_writer :type
      
      # unrestricted options storage for the widget type. this could be a list of options for a select, or extra configuration for a calendar widget.
      attr_accessor :type_options
    end

    def iname; :form end

    delegate :request_forgery_protection_token, :allow_forgery_protection, :to => :controller
    def protect_against_forgery? #:nodoc:
      allow_forgery_protection && request_forgery_protection_token
    end
  end
end
