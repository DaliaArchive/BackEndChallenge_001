class HistoriesController < ApplicationController

  def index
    robot = Robot.find(params[:robot_id])
    render json: robot.histories
  end
end
