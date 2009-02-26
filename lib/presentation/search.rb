module Presentation
  class Search < Base
    def iname; :search end
    
    def url
      request.path + '?' + request.query_parameters.except("search").to_param
    end
  end
end
