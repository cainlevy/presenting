require 'presentation/grid'

module Presentation
  # TODO: abstract what's common between Record and Grid into a shared module or reusable objects or something
  class Details < Grid
    def iname; :details end
    
    # The display title for this presentation. Will default based on the id.
    attr_accessor :title
    
    def fields=(args)
      args.each do |field|
        self.fields << field
      end
    end
    
    def fields
      @fields ||= Presenting::FieldSet.new(Presenting::Attribute, :name, :value)
    end
  end
end
