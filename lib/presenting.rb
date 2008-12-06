module Presenting
  class Helpers
    def present(object, type, options = {})
      klass = Presenting.const_get(type.to_s.camelcase)
      instance = klass.new(options) # initializer configuration
      # TODO: yield instance for block configuration
      instance.render(controller)
    end
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
