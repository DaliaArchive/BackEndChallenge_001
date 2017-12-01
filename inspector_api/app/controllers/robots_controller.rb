class RobotsController < ApplicationController
  before_action :set_robot, only: [:show,:history]

  # GET /robots
  def index
    render json: Robot.all, 
           each_serializer: RobotSerializer
  end

  # GET /robots/:id
  def show
    json_response(@robot.properties)
  end

  # PUT /robots/:name
  def update
    @robot = Robot.find_by_name(params[:name])
    unless @robot
      @robot = Robot.create!(name: params[:name])
    end
    merged_properties = (@robot.properties ||= {}).merge(robot_params[:properties])
    @robot.update_attributes(properties:merged_properties)
    head :no_content
  end

  # GET /robots/:name/history
  def history
    render json: @robot.robot_changelogs, 
           each_serializer: RobotChangelogSerializer
  end


  private
  def robot_params
    params.permit(properties: params[:properties].keys)
  end

  def set_robot
    @robot = Robot.find_by_name!(params[:name])
  end
end
