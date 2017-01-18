class RobotInfo < ActiveRecord::Base
  acts_as_paranoid
  validates :info, presence: true

end
