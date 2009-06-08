module Presentation
  class FieldSearch < Search
    # This method supports the configuration-on-initialization paradigm. It makes:
    #   present = Presentation::FieldSearch.new(:fields => [
    #     {:a => {:type => :list, :options => %w(foo bar baz)}},
    #     :b,
    #     {:c => :boolean}
    #   ])
    #
    # equivalent to:
    #
    #   present = Presentation::FieldSearch.new
    #   present.fields << {:a => {:type => :list, :options => %w(foo bar baz)}}
    #   present.fields << :b
    #   present.fields << {:c => :boolean}
    def fields=(args)
      args.each do |field|
        self.fields << field
      end
    end
    
    def fields
      @fields ||= Presenting::FieldSet.new(Field, :param, :type)
    end
    
    class Field
      include Presenting::Configurable
      
      # the display name of the field.
      attr_reader :name
      def name=(val)
        @name = val.is_a?(Symbol) ? val.to_s.titleize : val
      end
      
      # the parameter name of the field. note that this is not necessarily the name of a database column or record attribute.
      # it simply needs to be recognized as a "field" by the controller logic.
      attr_reader :param
      def param=(val)
        self.name ||= val
        @param = val.to_s.underscore.downcase.gsub(' ', '_')
      end
      
      # the type of search interface for this field. supported options:
      # * :text     (default)
      # * :checkbox
      # * :time     [planned]
      # * :list     [planned]
      def type
        @type ||= :text
      end
      attr_writer :type
      
      # extra options for the field.
      def options
        @options ||= {}
      end
      attr_writer :options
    end
  end
end
