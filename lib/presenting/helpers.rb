module Presenting
  module Helpers
    def present(object, presentation = nil, options = {}, &block)
      if presentation
        klass = "Presentation::#{presentation.to_s.camelcase}".constantize rescue nil
        if klass
          instance = klass.new(options, &block)
          instance.presentable = object
          instance.render
        elsif respond_to?(method_name = "present_#{presentation}")
          send(method_name, object, options)
        else
          raise ArgumentError, "unknown presentation `#{presentation}'"
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
    
    def present_by_class(object)
      case object
        when Array
        content_tag "ol" do
          object.collect do |i|
            content_tag "li", present(i)
          end.join
        end
        
        when Hash
        # sort by keys
        content_tag "dl" do
          object.keys.sort.collect do |k|
            content_tag("dt", k) +
            content_tag("dd", present(object[k]))
          end.join
        end
        
        when TrueClass, FalseClass
        object ? "True" : "False"
        
        when Date, Time, DateTime
        object.to_s :long
        
        else
        object.to_s
      end 
    end
  end
end
