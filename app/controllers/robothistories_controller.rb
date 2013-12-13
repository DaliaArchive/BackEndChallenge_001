class RobothistoriesController < ApplicationController
  
  def show
    #@robot = Robot.where(:name => params[:name]).includes(:robothistories)  
    @robothistories = Robothistory.where(:robots => {:name => params[:name]}).includes(:robot).order(:robothisies => :id)
    objbArray=Hash.new
    @robothistories.each do |history|
      objbArray["#{history.created_at}"]=Array.new if objbArray["#{history.created_at}"].blank?
      objArray = Array.new
      objArray << {"status" => history.status}
      objArray << {"changes" => { :"#{history.field}" => history.value}}
      objbArray["#{history.created_at}"] << objArray
    end
    render :json => objbArray.to_json
  end
end
