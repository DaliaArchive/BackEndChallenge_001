module DrRoboto
  class RobotAttribute < ActiveRecord::Base

    belongs_to :robot, touch: true

    validates :robot_id, presence: true
    validates :name, presence: true, length: (1..32)

  end
end