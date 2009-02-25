module Presenting::FormHelpers
  # TODO: eventually this will be smarter and able to pick an intelligent type all on its own
  def present(field)
    send("present_#{field.type}_input", field)
  end
  
  def present_string_input(field)
    text_field field.name
  end
  
  def present_text_input(field)
    text_area field.name
  end
  
  def present_password_input(field)
    password_field field.name
  end
  
  def present_boolean_input(field)
    check_box field.name
  end
  
  def present_dropdown_input(field)
    view.select_tag "#{object_name}[#{field.name}]", view.options_for_select(field.type_options, object.send(field.name))
  end
  
  def present_multi_select_input(field)
    view.select_tag "#{object_name}[#{field.name}][]", view.options_for_select(field.type_options, object.send(field.name)), :multiple => true
  end
  
  def present_radios_input(field)
    field.type_options.collect do |(display, value)|
      label("#{field.name}_#{value}", display) +
      radio_button(field.name, value)
    end.join
  end
  
  private
  
  def view
    @template
  end
end
