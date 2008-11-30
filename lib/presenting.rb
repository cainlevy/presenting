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
    # operates on an object collection
    # - Array
    # - WillPaginate
    # renders Hash or ActiveRecord
    # - need Hash adapter to allow dot syntax
    # column options
    # - render method
    # - - fixed strings
    # - - method of object
    # - - proc
    # - - other Presentation
    # - data types
    # - - nils make it hard to discover
    # - - ActiveRecord Column if available
    # - - configurable as backup? decorate Hash so it can be configured there?
    # - description (behavior: displays in column header)
    # - sortable?
    # title
    # id (defaults based on title)
    # links
    # - grid vs record
    # - label
    # - url
    # - - allow named urls
    # - - interpolate record variables (e.g. id)
    # - method (only GET, but POST/PUT/DELETE with appropriate javascript)
    # - other html attributes
    # - use procs for extra customization?
    # custom css classes for rows and/or cells
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
  # - tooltips for extended information (e.g. column description or truncated field text)
  # - basic form validation
  # - - required fields
end
