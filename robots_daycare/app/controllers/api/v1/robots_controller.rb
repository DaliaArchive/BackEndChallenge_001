class Api::V1::RobotsController < ApplicationController
  respond_to :json

  def index
    robots = Robot.all
    respond_with(robots)
  end


  def show
    robot = Robot.find(params[:id])
    respond_with(robot)
  end

  def update
    if Robot.where(id: params[:id]).empty?
      robot = Robot.create(robot_params)
      respond_with(robot)
    else
      robot = Robot.find(params[:id])
      robot.update_attributes(robot_params)
      respond_with(robot)
    end
  end

  def history
    robot = Robot.find(params[:robot_id])
    respond_with(robot.versions)
  end

  private

  def robot_params
    params.require(:robot).permit(:data).tap do |whitelisted| 
      whitelisted[:data] = params[:robot][:data]
    end
  end
end
