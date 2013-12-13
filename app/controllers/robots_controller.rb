class RobotsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :xml
  
  def index
    @robots = Robot.select('name,created_at').all  
    render :json => @robots.to_json
  end

  def show
    @robot = Robot.where(:name => params[:name]).first
    render :json => @robot.to_json
  end

  def new
    @robot = Robot.new
  end

  def edit
    @robot = Robot.where(:name => params[:name]).first
  end

  def create
    @robot = Robot.new(params[:robot])
    if @robot.save
      params[:robot].each do |key, value|
        if value.present?
          @robothistory = Robothistory.new
          @robothistory.status='create'
          @robothistory.robot_id = @robot.id
          @robothistory.field=key
          @robothistory.value=value
          @robothistory.save
        end
      end
      render :xml => @robot, :status => :created 
    else
      render :xml => @robot.errors, :status => :unprocessable_entity 
    end
    
    
    #respond_with @robot,  :location => showrobot_robots_path(@robot.name)
  end

  def update
    @robot = Robot.where(:name => params[:name]).first  
    @org_robot = Robot.where(:name => params[:name]).first  

    if @robot.update_attributes(params[:robot])
      if params[:robot].present?
        params[:robot].each do |key, value|
          if value.present?
            if @org_robot["#{key}"] != value
              @robothistory = Robothistory.new 
              @robothistory.status='update'
              @robothistory.robot_id = @robot.id
              @robothistory.field=key
              @robothistory.value=value
              @robothistory.save
            end
          end
        end
      end
      render :xml => @robot, :status => :ok 
    else
      render :xml => @robot.errors, :status => :unprocessable_entity
    end
  end
end
