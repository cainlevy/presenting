class Presenting::FieldSet < Array
  def initialize(field_class, primary, secondary)
    @klass = field_class
    @primary_attribute = primary
    @secondary_attribute = secondary
  end

  def <<(field)
    if field.is_a? Hash
      k, v = *field.to_a.first
      opts = v.is_a?(Hash) ? v : {@secondary_attribute => v}
      opts[@primary_attribute] = k
    else
      opts = {@primary_attribute => field}
    end
    super @klass.new(opts)
  end
  
  def [](key)
    detect{|i| i.send(@primary_attribute) == key}
  end
  
  def []=(key, val)
    self << {key => val}
  end
end
