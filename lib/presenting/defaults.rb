module Presenting::Defaults
  # Whether the columns in the Grid should be sortable by default
  mattr_accessor :grid_is_sortable
  self.grid_is_sortable = true
  
  # Whether fields should be sanitized by default
  mattr_accessor :sanitize_fields
  self.sanitize_fields = true
end

