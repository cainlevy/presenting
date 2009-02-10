module Presenting
  module Helpers
    def present(object, presentation = nil, options = {}, &block)
      if presentation
        method_name = "present_#{type}".to_sym
        if Presentation.const_defined?(klass_name = type.to_s.camelcase)
          klass = Presentation.const_get(klass_name)
          instance = klass.new(options, &block)
          instance.presentable = object
          instance.render
        elsif respond_to?(method_name = "present_#{presentation}")
          send(method_name, object, options)
        else
          raise "unknown presentation `#{presentation}'"
        end
      elsif object.respond_to?(:loaded?) # AssociationProxy
        present_association(object)
      else
        present_by_class(object)
      end
    end
    
    protected
    
    # TODO: special handling for associations (displaying activerecords)
    def present_association(object)
      present_by_class(object)
    end
    
    def present_by_class
      case object.class
        when Array
        content_tag "ol" do
          array.collect do |i|
            content_tag "li", present_type(i)
          end.join
        end
        
        when Hash
        # sort by keys
        content_tag "dl" do
          hash.keys.sort.collect do |k|
            content_tag("dt", k) +
            content_tag("dd", present_type(hash[k]))
          end.join
        end
        
        when Boolean
        v ? "True" : "False"
        
        when Date
        v.to_s :long # e.g. November 10, 2007
        
        when Time
        v.to_s :time # e.g. 06:10:17
        
        when DateTime
        v.to_s :long # e.g. December 04, 2007 15:10
        
        else
        v.to_s
      end 
    end
  end
end
