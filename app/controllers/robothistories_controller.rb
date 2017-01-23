class RobothistoriesController < ApplicationController
  
  def show
    history_hash = Robothistory.result_format(params[:name])
    if history_hash.blank?
      render :nothing => true, :status => :no_content 
    else
      render :json => history_hash.to_json
    end
  end
end
