class RobotsController < ApplicationController
  before_action :set_robot, only: [:show, :edit, :update, :destroy]
  skip_before_filter  :verify_authenticity_token

  # GET /robots
  # GET /robots.json
  def index
    @robots = Robot.all
  end

  # GET /robots/1
  # GET /robots/1.json
  def show
  end

  # PATCH/PUT /robots/1
  # PATCH/PUT /robots/1.json
  def update
    old_attribs = @robot.attribs
    new_attribs = JSON.parse(params[:attribs])
    @robot.attribs = @robot.attribs.merge(new_attribs)
    respond_to do |format|
      if @robot.save
        action = old_attribs.blank? ? "create" : "update"
        History.save_robot_history(@robot, old_attribs, new_attribs, action)
        format.json { render :show, status: :ok, location: @robot }
      else
        format.json { render json: @robot.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_robot
      @robot = Robot.find_or_create_by(name: params[:id])
    end

end
