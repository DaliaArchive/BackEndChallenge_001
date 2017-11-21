class RobotsController < ApplicationController
  # GET /robots
  def index
    @robots = Robot.all
    render 'index.json.jbuilder'
  end

  # GET /robots/name
  def show
    @robot = Robot.find_by(name: params[:name])
    if @robot
      render 'show.json.jbuilder'
    else
      render json: { message: 'Robot not found' }, status: 404
    end
  end
end
