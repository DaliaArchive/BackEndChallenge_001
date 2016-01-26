class Api::RobotsController < ApplicationController

  protect_from_forgery
  skip_before_action :verify_authenticity_token, if: :json_request?

  def show

    @robot = Robot.includes(:features).find_by_name(params[:id])

    respond_to do |format|

      format.json { render :json => @robot.current_revision }

    end

  end



  def update

    @robot = Robot.find_by_name(params[:id])

    if @robot

      @revision = Revision.create(type:"update")

    else

      @robot = Robot.create(name: params[:id])
      @revision = Revision.create(type:"create")

    end

    params.except(:action, :controller, :format, :id).each do |key, value|

      @revision.features << Feature.create(name: key, value: value)

    end

    @robot.revisions << @revision

    @robot.save

    respond_to do |format|

      format.json { render :json => @robot }

    end

  end

  protected

    def json_request?
      request.format.json?
    end

end