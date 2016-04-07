class Robot
  include Mongoid::Document
  include Mongoid::Timestamps
  embeds_many :histories, class_name: "History"
  
  field :name, type: String
  field :attribs, type: Hash, :default => Hash.new
  
  validates_presence_of :name
  
end
