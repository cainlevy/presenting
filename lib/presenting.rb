module Presenting
  # prior to Rails 2.3, you need to call this manually from your config/routes.rb
  def self.draw_routes(map)
    map.namespace(:presentation) do |presentation|
      presentation.resources :stylesheets, :only => [:show]
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
