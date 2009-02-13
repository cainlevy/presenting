class Presentation::StylesheetsController < ActionController::Base
  # TODO: page caching

  def show
    dir = File.join(File.dirname(__FILE__), '..', '..', 'assets', 'stylesheets')
    sheet = params[:id].split(',').collect{ |id| File.read("#{dir}/#{id}.css") }.join("\n")
    
    respond_to do |type|
      type.css {render :text => sheet}
    end
  end
end
