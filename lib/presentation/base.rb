module Presentation
  class Base
    include Presenting::Configurable
    
    def render
      view.render :partial => "presentations/#{self.class.to_s.split('::').last.underscore}"
    end
    
    attr_accessor :presentable
    
    ##
    ## begin ActionView compat
    ##
    
    attr_accessor :controller # not strictly for compat, but it makes the compat easy
    
    def request
      controller.request
    end
    
    def url_for(*args)
      controller.url_for(*args)
    end
    
    def params
      request.parameters
    end
    
    ## end ActionView compat
    
    protected
    
    # what the presentation is called in its templates
    def iname
      :presentation
    end
    
    # a reference to the view
    def view #:nodoc:
      @view ||= Presenting::View.new(ActionController::Base.view_paths, assigns_for_view, self)
    end
    
    def assigns_for_view
      {iname => self, :_request => request}
    end
    
  end
end
