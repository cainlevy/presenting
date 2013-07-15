class Presentation::AssetsController < ActionController::Base
  # TODO: this is a hack b/c of load order in the extracted Rails 4 gems, read
  # more in this pull request: https://github.com/rails/rails-observers/pull/8
  if Rails.version >= '4.0.0'
    include ActionController::Caching::Pages
  end

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
    dir = asset_path(:javascripts)
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
