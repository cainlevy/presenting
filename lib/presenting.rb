module Presenting
  # My Plan:
  # 1) start drafting API for standardized parameters
  # 2) work out basic configuration for Grid and Form
  # 3) work out proper markup for Grid and Form
  # 4) iterate on 2 and 3
  # 5) work out stylesheet bundling
  # 6) provide layout stylesheets for Grid and Form

  class Presentation
    # base class
    # each presentation has one or more view templates
    # each presentation is configurable
    # each presentation strives to encapsulate all relevant view logic
  end
  
  class Grid < Presentation
    # The id for this presentation.
    attr_accessor :id
    attr_accessor :title # TODO: defaults based on ID
    
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
      def initialize(options = {})
        options.each do |k, v|
          self.send("#{k}=", v)
        end
      end
    
      def name=(val)
        self.value ||= val # don't lazy define :value, because we're about to typecast here
        @name = val.to_s
      end
      attr_reader :name
    
      # Where a field's value comes from. Depends heavily on the data type you provide.
      # - String: fixed value (as provided)
      # - Symbol: a method on the record (no arguments)
      # - Proc: a custom block that accepts the record as an argument
      attr_accessor :value
    
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
  
  class Form < Presentation
    # define fields
    # group fields
    # nested model attributes (in or out of a group)
    # allow modular editing interfaces
    # configurable builder (markup generator)
    # - fieldset > label | div.input | div.notes
    # - ??
  end
  
  class List < Presentation
    # operates on a record collection like Grid
    # different markup (<LI> instead of <TD>)
    # may share all the same configuration as Grid but with a different render?
  end
  
  class Tree < Presentation
    # operates on a record collection like Grid
    # nesting
    # not meant to be a full javascript-based tree control
  end

  # TODO bundle stylesheets that can make things pretty. let users decide which ones to link.
  # - layout / typography
  # - colors
  
  # TODO bundle unobtrusive javascripts that can add behavior.
  # - jquery vs prototype (i'll develop jquery, and wait for prototype contributions)
  # - ajax links with html response
  # - - inline
  # - - modal dialog
  # - ajax links with js response
  # - ajax links with no response
  # - inline editing
  # - "dirty" form awareness
  # - tabbed forms
  # - tooltips for extended information (e.g. column description or truncated field text)
  # - basic form validation
  # - - required fields
end
