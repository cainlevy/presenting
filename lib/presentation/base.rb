module Presentation
  class Base
    include Presenting::Configurable
    
    # note: this would require rails 2.3 or engines to work. hmm.
    def render(controller = nil)
      view(controller).render :partial => "presentations/#{self.class.to_s.split('::').last.underscore}"
    end
    
    protected
    
    attr_reader :controller
    
    # what the presentation is called in its templates
    def iname
      :presentation
    end
    
    # a reference to the view
    def view(controller) #:nodoc:
      unless defined? @view
        # create a fresh view for this presentation. this is a clean slate for assigns.
        # but link it to the actual controller so that common helpers work properly.
        @view = ActionView::Base.new(ActionController::Base.view_paths, assigns_for_view, controller)
        # add in the application helpers
        @view.extend ActionController::Base.master_helper_module
      end
      @view
    end
    
    def assigns_for_view
      {iname => self}
    end
    
  end
  
  class Search < Base
    # operates on a data model
    # fields have search types
    # one of four search types
    # - single value
    # - one value per field
    # - one value/operator per field
    # - multiple values/operators per field
  end
  
  class Filter < Base
    # like search but for filters/scopes (searches that toggle on and off w/o arguments)
  end
  
  class Form < Base
    # define fields
    # group fields
    # nested model attributes (in or out of a group)
    # allow modular editing interfaces
    # configurable builder (markup generator)
    # - fieldset > label | div.input | div.notes
    # - ??
  end
  
  class List < Base
    # operates on a record collection like Grid
    # different markup (<LI> instead of <TD>)
    # may share all the same configuration as Grid but with a different render?
  end
  
  class Tree < Base
    # operates on a record collection like Grid
    # nesting
    # not meant to be a full javascript-based tree control
  end
end
