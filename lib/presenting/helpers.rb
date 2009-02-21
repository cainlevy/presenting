module Presenting
  module Helpers
    def presentation_stylesheets(*args)
      stylesheet_link_tag presentation_stylesheet_path(args.sort.join(','))
    end
    
    def presentation_javascript(*args)
      javascript_include_tag presentation_javascript_path(args.sort.join(','))
    end
    
    def present(*args, &block)
      options = args.length > 1 ? args.extract_options! : {}
      
      if args.first.is_a? Symbol
        object, presentation = nil, args.first
      else
        object, presentation = args.first, args.second
      end

      if presentation
        klass = "Presentation::#{presentation.to_s.camelcase}".constantize rescue nil
        if klass
          instance = klass.new(options, &block)
          instance.presentable = object
          instance.controller = controller
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
    
    # presents a text search widget for the given field (a Presentation::FieldSearch::Field, probably)
    def present_text_search(field, options = {})
      current_value = (params[:search][field.param][:value] rescue nil)
      text_field_tag options[:name], h(current_value)
    end
    
    # presents a checkbox search widget for the given field (a Presentation::FieldSearch::Field, probably)
    def present_checkbox_search(field, options = {})
      current_value = (params[:search][field.param][:value] rescue nil)
      check_box_tag options[:name], '1', current_value == '1'
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
