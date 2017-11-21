class RobotsController < ApplicationController
  before_action :set_robot, only: %i[show update]

  # GET /robots
  def index
    @robots = Robot.all
    render 'index.json.jbuilder'
  end

  # GET /robots/name
  def show
    if @robot
      render 'show.json.jbuilder'
    else
      render json: { message: 'Robot not found' }, status: 404
    end
  end

  # PATCH/PUT /robots/name
  def update
    # Robot already exists
    if @robot
      attributes_params.each do |attribute_params|
        attribute = @robot.robot_attributes.find_or_initialize_by(key: attribute_params[:key])
        attribute.value = attribute_params[:value]
        attribute.save
      end
    # Robot does not exist
    else
      @robot = Robot.create(name: params[:name])
      @robot.robot_attributes.create(attributes_params)
    end
    render 'show.json.jbuilder'
  end

  private

  def set_robot
    @robot = Robot.find_by(name: params[:name])
  end

  def robot_params
    params.require(:robot).permit!.to_h
  end

  def attributes_params
    robot_params.map { |attribute| { key: attribute[0], value: attribute[1] } }
  end
end
