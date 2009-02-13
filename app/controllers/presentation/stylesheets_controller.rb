class Presentation::StylesheetsController < ActionController::Base
  def show
    # TODO: returns the named stylesheets. page caching.
    render :nothing => true
  end
end
