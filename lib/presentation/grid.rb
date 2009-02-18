module Presentation
  class Grid < Base
    # The id for this presentation.
    attr_accessor :id
    
    attr_writer :title
    def title
      @title ||= self.id.titleize
    end
    
    # Paradigm Example:
    #   Grid.new(:fields => [
    #     :email,
    #     "Full Name" => proc{|r| [r.first_name, r.last_name].join(' ')},
    #     "Roles" => {:value => :roles, :type => :collection}
    #   ])
    #
    # Is equivalent to:
    #   g = Grid.new
    #   g.fields << :email
    #   g.fields << {"Full Name" => proc{|r| [r.first_name, r.last_name].join(' ')},
    #   g.fields << {"Roles" => {:value => :roles, :type => :collection}}
    def fields=(args)
      args.each do |field|
        self.fields << field
      end
    end
    
    def fields
      @fields ||= FieldSet.new
    end
    
    def iname; :grid end
    
    class FieldSet < Array
      # Accepts field specifications to varying degrees of detail.
      # If you assign a Symbol or String, that will be the field's :name and :value.
      # If you assign a Hash with one key/value pair, the key will be the :name
      # If you assign a Hash, the value may either be another Hash of options or the :value itself.
      def <<(field)
        if field.is_a? Hash
          k, v = *field.to_a.first
          opts = v.is_a?(Hash) ? v : {:value => v}
          opts[:name] = k
        else
          opts = {:name => field}
        end
        super Field.new(opts)
      end
    end
    
    class Field
      include Presenting::Configurable
    
      def name=(val)
        self.value ||= val # don't lazy define :value, because we're about to typecast here
        if val.is_a? Symbol
          @name = val.to_s.titleize
        else
          @name = val.to_s
        end
      end
      attr_reader :name
    
      # Where a field's value comes from. Depends heavily on the data type you provide.
      # - String: fixed value (as provided)
      # - Symbol: a method on the record (no arguments)
      # - Proc: a custom block that accepts the record as an argument
      attr_accessor :value
      
      def value_from(obj) #:nodoc:
        v = case value
          when Symbol: obj.send(value)
          when String: value
          when Proc:   value.call(obj)
        end
        
        sanitize? ? Presenting::Sanitize.h(v) : v
      end
      
      # whether html should be sanitize. right now this actually means html escaping.
      attr_writer :sanitize
      def sanitize?
        unless defined? @sanitize
          @sanitize = true
        end
        @sanitize
      end

      # TODO: discover "type" from data class (ActiveRecord) if available
      # TODO: decorate a Hash object so type is specifiable there as well
      # PLAN: type should determine how a field renders. custom types for custom renders.
      attr_accessor :type
      
      # PLAN: a field's description would appear in the header column, perhaps only visibly in a tooltip
      attr_accessor :description
      
      # PLAN: discover whether a field is sortable (via SQL), but allow overrides
      attr_accessor :sortable
    end
    
    # operates on an object collection
    # - Array
    # - WillPaginate
    # renders Hash or ActiveRecord
    # - need Hash adapter to allow dot syntax
    # title
    # id (defaults based on title)
    # links
    # - grid vs record
    # - label
    # - url
    # - - allow named urls
    # - - interpolate record variables (e.g. id)
    # - method (only GET, but POST/PUT/DELETE with appropriate javascript)
    # - other html attributes
    # - use procs for extra customization?
    # custom css classes for rows and/or cells
  end
end
