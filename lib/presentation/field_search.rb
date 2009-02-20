module Presentation
  class FieldSearch < Base
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
      @fields ||= FieldSet.new
    end
    
    class FieldSet < Array
      def <<(field)
        if field.is_a?(Hash)
          k, v = *field.to_a.first
          opts = v.is_a?(Hash) ? v : {:type => v}
          opts[:param] = k
        else
          opts = {:param => field}
        end
        super Field.new(opts)
      end
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
    end
    
    def iname; :search end
  end
end
