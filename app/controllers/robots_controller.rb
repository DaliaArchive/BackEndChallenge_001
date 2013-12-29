class RobotsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json
  
  def index
    @robots = Robot.select('name,created_at').all  
    render :json => @robots.to_json
  end

  def show
    @robot = Robot.where(:name => params[:name]).first
    if @robot
      render :json => @robot.to_json
    else
      render :nothing => true, :status => :no_content 
    end
  end

  def create
    @robot = Robot.new
    @robot.name = params[:robot][:name] if params[:robot][:name].present?
    @robot.robot_datas = params[:robot][:robot_datas].to_json if params[:robot][:robot_datas].present?

    if @robot.save
      Robot.create_robot(params[:robot], @robot.id)
      render :json => @robot, :status => :created 
    else
      render :json => @robot.errors, :status => :unprocessable_entity 
    end
  end

  def update
    if @robot = Robot.where(:name => params[:name]).first 
      data_hash={}
      data_hash = ActiveSupport::JSON.decode(@robot.robot_datas) if  @robot.robot_datas.present?#for management robot_datas
      update_hash={} #for save change column and value
      if params[:robot][:robot_datas].present?
        params[:robot][:robot_datas].each do | key, value |
          if data_hash["#{key}"] != value.to_s || data_hash["#{key}"].blank?
            update_hash["#{key}"] = value
          end
          data_hash["#{key}"] = value
        end
      end
      
      @robot.robot_datas=data_hash.to_json
      
      if @robot.save
        Robot.update_checking(update_hash, @robot.id)
        render :json => @robot, :status => :ok 
      else
        render :json => @robot.errors, :status => :unprocessable_entity
      end
    else
      render :nothing => true, :status => :no_content 
    end
  end
end
