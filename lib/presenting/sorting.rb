module Presenting
  class Sorting
    include Presenting::Configurable
    
    # I want to support two configuration formats:
    #
    #   SearchConditions.new(:fields => [:first_name, :last_name, :email])
    #
    #   SearchConditions.new(:fields => {
    #    'name' => 'CONCAT(first_name, last_name)',
    #    'email' => 'email_address'
    #   })
    def fields=(obj)
      case obj
        when Array
        obj.each do |name| fields << name end
        
        when Hash
        obj.each do |k, v|
          fields << {k => v}
        end 
      end
    end
    
    def fields
      @fields ||= FieldSet.new
    end
    
    def to_sql(param)
      fields.each do |field|
        # search for and return the first known field
        return "#{field.sql} #{desc_or_asc param[field.name]}" if param[field.name]
      end unless param.blank?
      # no known fields found
      default
    end
    
    # The default sorting, if no known fields are found in the parameters.
    # Default sorting is specified by name/direction, using an array.
    #
    # Example:
    #
    #   @sorting.default = [:name, 'asc']
    #
    def default
      @default ||= "#{fields.first.sql} ASC"
    end
    def default=(val)
      @default = "#{fields.find{|f| f.name == val.first.to_s}.sql} #{desc_or_asc val.second}"
    end
    
    protected
    
    def desc_or_asc(val)
      val.to_s.downcase == 'desc' ? 'DESC' : 'ASC'
    end
    
    class FieldSet < Array
      def <<(val)
        if val.is_a? Hash
          k, v = *val.to_a.first
          opts = v.is_a?(Hash) ? v : {:sql => v}
          opts[:name] = k
        else
          opts = {:name => val}
        end
        super Field.new(opts)
      end
    end
    
    class Field
      include Presenting::Configurable
      
      # required (this is what appears in the parameter hash)
      attr_reader :name
      def name=(val)
        @name = val.to_s
      end

      # sql field (default == name)
      attr_writer :sql
      def sql
        @sql ||= self.name.to_s
      end
    end
  end
end
