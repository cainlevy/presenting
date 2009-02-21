class Presentation::AssetsController < ActionController::Base
  # TODO: consider packaging a minifier so we get the perfect solution: a cached, minified bundle of assets
  caches_page :stylesheet, :javascript

  def stylesheet
    dir = asset_path(:stylesheets)
    sheet = params[:id].split(',').collect{ |id| File.read("#{dir}/#{id}.css") }.join("\n")
    
    respond_to do |type|
      type.css {render :text => sheet}
    end
  end
  
  # TODO: bundle unobtrusive javascripts that can add behavior.
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
  # TODO: tests for ujs
  def javascript
    dir = asset_path(:javascript)
    script = params[:id].split(',').collect{ |id| File.read("#{dir}/#{id}.js") }.join("\n")
    
    respond_to do |type|
      type.js {render :text => script}
    end
  end
  
  protected
  
  def asset_path(type)
    File.join(File.dirname(__FILE__), '..', '..', 'assets', type.to_s)
  end
end
