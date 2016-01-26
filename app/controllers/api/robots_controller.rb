class Api::RobotsController < ApplicationController

  protect_from_forgery
  skip_before_action :verify_authenticity_token, if: :json_request?

  # Return a list of all robots
  def index

    @robots = Robot.all

    respond_to do |format|

      format.json { render :json => @robots.list }

    end

  end


  # Return a formatted list of  robot current features
  def show

    @robot = Robot.includes(:features).find_by_name(params[:id])

    respond_to do |format|

      format.json { render :json => @robot.current_revision }

    end

  end

  # Return a dettailed list of all revisions and changes for a robot
  def history

    @robot = Robot.find_by_name(params[:id])

    respond_to do |format|

      format.json { render :json => @robot.history }

    end

  end

  # Update the features of a robot or create a new one if it doesn't exist
  def update

    @robot = Robot.find_by_name(params[:id])

    # if robot exist
    if @robot
      # create a revision of type update
      @revision = Revision.create(type:"update")

    # if robot don't exist
    else
      # create a new robot and set up the first revison of type update
      @robot = Robot.create(name: params[:id])
      @revision = Revision.create(type:"create")

    end

    Fetch the query string parameters
    params.except(:action, :controller, :format, :id).each do |key, value|

      #add the parameters as new feature associated to the current revision
      @revision.features << Feature.create(name: key, value: value)

    end

    #associate the current revision with the robot
    @robot.revisions << @revision
    # save the robot and send the response
    @robot.save

    respond_to do |format|

      format.json { render :json => @robot.current_revision }

    end

  end

  protected

    def json_request?
      request.format.json?
    end

end