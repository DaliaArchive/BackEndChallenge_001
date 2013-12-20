module DrRoboto
  class Robot < ActiveRecord::Base

    has_many :robot_attributes

    validates :name, presence: true, length: (1..32)

  end
end