class Api::V1::RobotsController < ApplicationController
  respond_to :json


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

  def robot_params
    params.require(:robot).permit(:data).tap do |whitelisted| 
      whitelisted[:data] = params[:robot][:data]
    end
  end
end
