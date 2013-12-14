class RobotsController < ApplicationController

  def create_or_update
    unless Robot.where(:id => params[:robot][:id]).exists?
      Robot.create(params[:robot])
      render :status => 201
    end
  end

end
