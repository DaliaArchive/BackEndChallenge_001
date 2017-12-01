class Robot < ApplicationRecord
  validates :name, presence: true
  has_many :robot_changelogs

  after_create RobotChangelog.new
  after_update RobotChangelog.new 

  def to_param
    "#{name}".parameterize
  end
end
