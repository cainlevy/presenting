class Presentation::AssetsController < ActionController::Base
  # TODO: page caching

  def stylesheet
    dir = asset_path(:stylesheets)
    sheet = params[:id].split(',').collect{ |id| File.read("#{dir}/#{id}.css") }.join("\n")
    
    respond_to do |type|
      type.css {render :text => sheet}
    end
  end
  
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
