module RobotsHelper

  def index
    json Robot.all.map { |robot| {name: robot.name, last_update: robot.last_update} }
  end

  def show
    json find_robot.robot_info.info
  end

  def create
    attrs =
        begin
          JSON.parse(request.body.read)
        rescue JSON::ParserError
          raise InvalidJsonBody.new
        end
    robot = Robot.create(robot_info: RobotInfo.new(info: attrs))
    unless robot.errors.blank?
      halt 422, json(status: 'error', message: robot.errors.to_json)
    end
    halt json(status: 'success', id: robot.id)
  end

  # The requirements present a behavior limitation that once an attribute is
  # set it is impossible to remove completely, only set to null
  def update
    attrs =
        begin
          JSON.parse(request.body.read)
        rescue JSON::ParserError
          raise InvalidJsonBody.new
        end
    robot = find_robot
    # merge attributes to avoid overriding old robot data
    new_info = robot.robot_info.info.merge(attrs)
    # compare old attributes with new attributes and see if a new revision is needed
    if robot.robot_info.info != new_info
      # paranoia gem creates a new revision here and marks the old one as destroyed
      # so we keep the historical data
      robot.update(robot_info: RobotInfo.new(info: new_info))
      unless robot.errors.blank?
        halt 422, json(status: 'error', message: robot.errors.to_json)
      end
    end
    halt json(status: 'success', id: robot.id)
  end

  def destroy
    robot = find_robot
    if robot.destroy
      json status: 'success'
    else
      halt 422, json(status: 'error', message: robot.errors.to_json)
    end
  end

  def history
    history = find_robot.history
    history.each { |entry| entry['type'] = 'update' }
    history.first['type'] = 'create'
    halt json history
  end

  private
  def find_robot
    if /^XX[0-9]*$/.match(params[:name]).nil?
      raise IllegalName
    end
    Robot.find(params[:name][2..-1])
  end

end