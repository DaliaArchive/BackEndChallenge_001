class Api::RobotsController < ApplicationController

  protect_from_forgery
  skip_before_action :verify_authenticity_token, if: :json_request?

  # Returns a list of all robots
  def index

    @robots = Robot.all

    respond_to do |format|

      format.json { render :json => @robots.list }

    end

  end


  # Returns a formatted list of  robot current features
  def show

    @robot = Robot.includes(:features).find_by_name(params[:id])

    if @robot

      respond_to do |format|

        format.json { render :json => @robot.current_features }

      end

    else

      respond_to do |format|

        format.json { render :json => { error: "Robot not found" } , status: 404}

      end

    end

  end

  # Returns a dettailed list of all revisions and changes for a robot
  def history

    @robot = Robot.find_by_name(params[:id])

    respond_to do |format|

      format.json { render :json => @robot.history }

    end

  end

  # Updates the features of a robot or creates a new one if it doesn't exist
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

    # Fetches the query string parameters
    params.except(:action, :controller, :format, :id).each do |key, value|

      #adds the parameters as new feature associated to the current revision
      @revision.features << Feature.create(name: key, value: value)

    end

    #associates the current revision with the robot
    @robot.revisions << @revision
    # saves the robot and sends the response
    @robot.save

    respond_to do |format|

      format.json { render :json => @robot.current_features }

    end

  end

  protected

    def json_request?
      request.format.json?
    end

end