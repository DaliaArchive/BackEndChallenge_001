class Robot < ActiveRecord::Base
  attr_accessible :age, :antenna_number, :color, :eyes_number, :name, :size, :status, :weight
  validates :name, :presence => true, :uniqueness => true
                    
  has_many :robothistories
end
