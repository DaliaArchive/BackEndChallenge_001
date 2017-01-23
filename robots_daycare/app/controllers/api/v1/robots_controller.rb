class Api::V1::RobotsController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::ImplicitRender
  respond_to :json

  def show
    @project = Robot.find(params[:id])
    respond_with(@project)
  end

end