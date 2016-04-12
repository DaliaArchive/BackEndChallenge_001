class HistoriesController < ApplicationController

  before_action :set_robot, only: [:index]
  skip_before_filter  :verify_authenticity_token

  def index
    begin
      respond_to do |format|
        if @robot
          format.json { render json: @robot.histories.to_json(:except => :_id) }
        else
          format.json { render json: {error: "No robot record found by given name"} }
        end
      end
    rescue
      render json: processing_error
    end
  end

  private
  def set_robot
    @robot = Robot.find_by(name: params[:robot_id])
  end

end
