class Api::V1::RobotsController < ApplicationController
  respond_to :json


  def show
    robot = Robot.find(params[:id])
    respond_with(robot)
  end

  def update
    robot = Robot.where(params[:id]).first
    robot.update_attributes(robot_params)
    respond_with(robot)
  end

  def robot_params
    params.require(:robot).permit(:size, :weight, :status, :color)
  end
end