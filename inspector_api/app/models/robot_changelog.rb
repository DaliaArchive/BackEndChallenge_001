class RobotChangelog < ApplicationRecord
  belongs_to :robot

  def track_create(robot)
    robot.robot_changelogs.create(changeset: robot.changes[:properties] || {}, type_str: :create)
  end

  def track_update(robot)
    return unless check_changes?(robot)
    robot.robot_changelogs.create(changeset: robot.changes[:properties], type_str: :update)
  end

  alias after_create track_create
  alias after_update track_update

  private
  def check_changes?(robot)
    robot.changes[:properties] && robot.changes[:properties].size > 0
  end
end
