class Revision < ActiveRecord::Base
  self.inheritance_column = nil
  belongs_to :robot
  has_many :features
end
