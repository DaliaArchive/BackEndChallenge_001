class History
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :transaction_type, type: String
  field :changed_attribs, type: Array, :default => Array.new
  
  embedded_in :robot, :inverse_of => :histories
  
end
