class RobotsController < ApplicationController

  def create_or_update
    robot = Robot.new(params[:robot])
    return render :status => 400 , :json=> {:error_message => 'Robot parameters are invalid.' } unless robot.valid?
    robot.upsert
    render :status => 200, :json => {:robot => robot.to_json}
  end

end
