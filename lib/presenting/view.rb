class Presenting::View < ActionView::Base
  delegate :protect_against_forgery?, :form_authenticity_token, :url_for, :to => :controller
end
