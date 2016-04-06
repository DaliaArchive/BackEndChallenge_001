class RobotsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # GET /robots.json
  def index
    @robots = Robot.all
  end

  # GET /robots/1.json
  def show
    @robot = Robot.find(params[:id])
  end

  # POST /robots/maintain.json
  def maintain
    @robot = if robot_params[:id]
        Robot.find(robot_params[:id])
      else
        Robot.create(robot_params.permit(:name))
      end

    features = robot_params.require(:features).map {|feature_params| Feature.new(feature_params) }
    if @robot.maintain(features)
      render :show, status: :ok, location: @robot
    else
      render json: @robot.errors, status: :unprocessable_entity
    end
  end

  # GET /robots/1/maintenance_records.json
  def maintenance_records
    @maintenance_records = Robot.find(params[:id]).maintenance_records
  end

  private

  def robot_params
    params.require(:robot).permit(:id, :name, features: [:key, :value])
  end
end
