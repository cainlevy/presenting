module Presentation
  class Base
    include Presenting::Configurable

    def render
      view.render :partial => "presentations/#{self.class.to_s.split('::').last.underscore}"
    end

    attr_accessor :presentable

    attr_accessor :controller
    delegate :request, :form_authenticity_token, :url_for, :params, :to => 'controller'

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
