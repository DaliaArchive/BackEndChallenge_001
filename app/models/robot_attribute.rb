class RobotAttribute < ApplicationRecord
  belongs_to :robot, touch: true
  audited associated_with: :robot, only: :value
end
