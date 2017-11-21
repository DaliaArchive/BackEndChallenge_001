class RobotAttribute < ApplicationRecord
  belongs_to :robot, touch: true
end
