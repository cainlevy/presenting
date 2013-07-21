module Presenting
  module Helpers
    def presentation_stylesheets(*args)
      warn "[DEPRECATION] presentation_stylesheets is deprecated. Please use the stylesheets" <<
           "that are copied to public/stylesheets/presenting/* on boot."
      stylesheet_link_tag presentation_stylesheet_path(args.sort.join(','), :format => 'css')
    end

    def presentation_javascript(*args)
      warn "[DEPRECATION] presentation_javascript is deprecated. Please use the javascripts" <<
           "that are copied to public/javascripts/presenting/* on boot."
      javascript_include_tag presentation_javascript_path(args.sort.join(','), :format => 'js')
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
        elsif respond_to?(method_name = "present_#{presentation}", true)
          send(method_name, object, options)
        else
          raise ArgumentError, "unknown presentation `#{presentation}'"
        end
      elsif object.respond_to?(:loaded?) # AssociationProxy
        present_association(object, options)
      else
        present_by_class(object, options)
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
      check_box_tag options[:name], '1', current_value.to_s == '1'
    end

    # presents a dropdown/select search widget for the given field (a Presentation::FieldSearch::Field, probably)
    def present_dropdown_search(field, options = {})
      current_value = (params[:search][field.param][:value] rescue nil)
      select_tag options[:name], options_for_select(normalize_dropdown_options_to_strings(field.options), current_value)
    end

    protected

    # We want to normalize the value elements of the dropdown options to strings so that
    # they will match against params[:search].
    #
    # Need to handle the three different dropdown options formats:
    # * array of strings
    # * array of arrays
    # * hash
    def normalize_dropdown_options_to_strings(options)
      options.to_a.map do |element|
        if element.is_a? String
          [element, element]
        else
          [element.first, element.last.to_s]
        end
      end
    end

    # TODO: special handling for associations (displaying activerecords)
    def present_association(object, options = {})
      present_by_class(object, options)
    end

    def present_by_class(object, options = {})
      case object
      when Array
        content_tag "ol" do
          object.collect do |i|
            content_tag "li", present(i, options)
          end.join.html_safe
        end

      when Hash
        # sort by keys
        content_tag "dl" do
          object.keys.sort.collect do |k|
            content_tag("dt", k) +
            content_tag("dd", present(object[k], options))
          end.join.html_safe
        end

      when TrueClass, FalseClass
        object ? "True" : "False"

      when Date, Time, DateTime
        l(object, :format => :default)

      else
        options[:raw] ? object.to_s.html_safe : object.to_s
      end
    end
  end
end
