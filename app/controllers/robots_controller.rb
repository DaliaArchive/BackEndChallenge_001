class RobotsController < ApplicationController

  def create_or_update
    robot = Robot.new(params[:robot])
    return render :status => 400 , :json => { :error_message => 'Robot parameters are invalid.' } unless robot.valid?
    robot.upsert
    render :status => 200, :json => {:robot => robot}
  end

  def show
    robot = Robot.where(:id => params[:id]).first
    return render :status => 400 , :json => { :error_message => "Robot with id:#{params[:id]} does not exist" } if robot.nil?
    render :status => 200, :json => {:robot => robot}
  end

  def index
    render :status => 200, :json => {:robots => Robot.all}
  end

end
