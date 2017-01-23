class RobotInfo < ActiveRecord::Base
  acts_as_paranoid
  validates :info, exclusion: { in: [nil] }
end
