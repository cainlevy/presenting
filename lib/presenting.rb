module Presenting
  # My Plan:
  # 1) start drafting API for standardized parameters
  # 2) work out basic configuration for Grid and Form
  # 3) work out proper markup for Grid and Form
  # 4) iterate on 2 and 3
  # 5) work out stylesheet bundling
  # 6) provide layout stylesheets for Grid and Form

  class Presentation
    # base class
    # each presentation has one or more view templates
    # each presentation is configurable
    # each presentation strives to encapsulate all relevant view logic
  end
  
  class Grid < Presentation
    # configure columns, data types, etc.
    # allow fields to be strings, methods, procs, or other presentations
    # allow custom css classes for rows and/or cells
    # copy ideas from my old Presenting plugin
  end
  
  class Form < Presentation
    # define fields
    # group fields
    # nested model attributes (in or out of a group)
    # allow modular editing interfaces
    # configurable builder (markup generator)
    # - fieldset > label | div.input | div.notes
    # - ??
  end
  
  class List < Presentation
    # operates on a record collection like Grid
    # different markup (<LI> instead of <TD>)
    # may share all the same configuration as Grid but with a different render?
  end
  
  class Tree < Presentation
    # operates on a record collection like Grid
    # nesting
    # not meant to be a full javascript-based tree control
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
end
