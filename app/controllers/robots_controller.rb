class RobotsController < ApplicationController

  def index
    @robots = Robot.all

    render json: @robots.as_json(only: [:name], methods: [:id])
  end

  def show
    @robot = Robot.find(params[:id])

    render json: @robot.attributes.as_json(except: [:_id, :histories])
  end

  def update
    @robot = Robot.find(params[:id])

    if @robot.update(robot_params)
      render json: @robot.attributes.as_json(except: [:_id, :histories]), status: :ok
    else
      render json: @robot.errors, status: :unprocessable_entity
    end
  end

  protected

    def robot_params
      params.require(:robot).require(:attributes).permit(params[:robot][:attributes].keys)
    end
end
