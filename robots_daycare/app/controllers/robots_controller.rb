class RobotsController < ApplicationController

  before_action :set_robot, only: [:show, :edit, :update, :destroy]
  skip_before_filter  :verify_authenticity_token

  # GET /robots.json
  def index
    begin
      @robots = Robot.all
    rescue
      render json: processing_error
    end
  end

  # GET /robots/1.json
  def show
  end

  # PATCH/PUT /robots/1.json
  def update
    begin
      old_attribs = @robot.attribs
      @robot.attribs = @robot.attribs.merge(params[:attribs])
      respond_to do |format|
        if @robot.save
          @robot.save_history(old_attribs)
          format.json { render :show, status: :ok, location: @robot }
        else
          format.json { render json: @robot.errors, status: :unprocessable_entity }
        end
      end
    rescue
      render json: processing_error
    end
  end

  private
  def set_robot
    @robot = Robot.find_or_create_by(name: params[:id])
  end

end
