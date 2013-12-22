class RobotsController < ApplicationController
  include ActionController::MimeResponds # required for respond_to

  def index
    robots = Robot.only([:name, :last_update])

    respond_to do |format|
      if robots != []
        # mongoid doesn't allow for a combination of "only" and "without", so the "_id" field should be removed here
        format.json { render :json => robots.to_json(:except => :_id), status: 200 }
      else
        format.json { render :json => { message: "No robots exist in the database!" } }
      end
    end
  end

  def show
    robot = Robot.find_by(name: params[:name])

    respond_to do |format|
      if robot
        format.json { render :json => robot.to_json(:except => [:_id, :last_update]), status: 200 }
      else
        format.json { render :json => { error_message: "No robot with name #{params[:name]} exists in the database!" }, status: 404 }
      end
    end
  end

end
