class Presentation::StylesheetsController < ActionController::Base
  # TODO: page caching
  # TODO: support comma-delimited list of stylesheets (bundling)

  def show
    dir = File.join(File.dirname(__FILE__), '..', '..', 'assets', 'stylesheets')
    respond_to do |type|
      type.css {render :text => File.read("#{dir}/#{params[:id]}.css")}
    end
  end
end
