class Robot < ActiveRecord::Base
  has_one :robot_info, autosave: true, required: true, dependent: :destroy

  def name
    "XX#{id}"
  end

  def last_update
    updated_at.strftime("%Y-%m-%d")
  end

  def changes(prev, current)
    h = {}
    current.each do |key, value|
      h[key] = [prev[key], value] if prev[key] != value
    end
    h
  end

  def history
    previous = {}
    RobotInfo.unscoped.where(robot_id: self.id).map(&:info).map do |current|
      {changes: changes(previous, previous = current)}
    end
  end

end
