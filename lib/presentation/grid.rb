module Presentation
  # TODO: ability to render a hash
  # TODO: custom css classes for rows and/or cells
  # TODO: document or complain for required options -- id and fields
  # TODO: make fields= accept an ActiveRecord::Base.columns array for a default field set
  class Grid < Base
    # The id for this presentation. Required.
    attr_accessor :id
    
    # The display title for this presentation. Will default based on the id.
    attr_writer :title
    def title
      @title ||= self.id.titleize
    end
    
    # Paradigm Example:
    #   Grid.new(:fields => [
    #     :email,
    #     {"Full Name" => proc{|r| [r.first_name, r.last_name].join(' ')}},
    #     {"Roles" => {:value => :roles, :type => :collection}}
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
      @fields ||= Presenting::FieldSet.new(Field, :name, :value)
    end
    
    def colspan
      @colspan ||= fields.size + (record_links.empty? ? 0 : 1)
    end
    
    def iname; :grid end

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
      # consider: by default, do not sanitize if value is a String?
      attr_writer :sanitize
      def sanitize?
        unless defined? @sanitize
          @sanitize = true
        end
        @sanitize
      end

      ##
      ## Planned
      ##

      # TODO: discover "type" from data class (ActiveRecord) if available
      # TODO: decorate a Hash object so type is specifiable there as well
      # PLAN: type should determine how a field renders. custom types for custom renders. this should be the second option to present().
      attr_accessor :type
      
      # PLAN: a field's description would appear in the header column, perhaps only visibly in a tooltip
      attr_accessor :description
      
      # PLAN: discover whether a field is sortable (via SQL), but allow overrides
      attr_accessor :sortable
      
      # PLAN: any field may be linked. this would happen after :value and :type.
      attr_accessor :link
    end

    # Links are an area where I almost made the mistake of too much configuration. Presentations are configured in the view,
    # and all of the view helpers are available. When I looked at the (simple) configuration I was building and realized that
    # I could just as easily take the result of link_to, well, I felt a little silly.
    #
    # Compare:
    #
    #   @grid.links = [
    #     {:name => 'Foo', :url => foo_path, :class => 'foo'}
    #   ]
    #
    # vs:
    #
    #   @grid.links = [
    #     link_to('Foo', foo_path, :class => 'foo')
    #   ]
    #
    # Not only is the second example (the supported example, by the way) shorter and cleaner, it encourages the developer
    # to stay in touch with the Rails internals and therefore discourages a configuration-heavy mindset.
    def links=(set)
      set.each do |link|
        raise ArgumentError, "Links must be strings, such as the output of link_to()." unless link.is_a?(String)
        links << link
      end
    end
    def links
      @links ||= []
    end
    
    # Like links, except the link will appear for each record. This means that the link must be a block that accepts the
    # record as its argument. For example:
    #
    # @grid.record_links = [
    #   proc{|record| link_to("Foo", foo_path(record), :class => 'foo') }
    # ]
    #
    def record_links=(set)
      set.compact.each do |link|
        raise ArgumentError, "Record links must be blocks that accept the record as an argument." unless link.respond_to?(:call) and link.arity == 1
        record_links << link
      end
    end
    def record_links
      @record_links ||= []
    end
    
    def paginate?
      defined? WillPaginate and presentable.is_a?(WillPaginate::Collection)
    end
  end
end
