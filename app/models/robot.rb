class Robot
  include Mongoid::Document

  validates :name, uniqueness: true

  field :name, type: String
end
