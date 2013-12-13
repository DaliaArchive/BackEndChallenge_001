class Robothistory < ActiveRecord::Base
  attr_accessible :field, :status, :value
  
  belongs_to :robot
end
