class RobotsController < ApplicationController
  before_action :set_robot, only: %i[show update history]

  # GET /robots
  def index
    @robots = Robot.all
    render 'index.json.jbuilder'
  end

  # GET /robots/name
  def show
    if @robot
      render 'show.json.jbuilder'
    else
      render json: { message: 'Robot not found' }, status: 404
    end
  end

  # PATCH/PUT /robots/name
  def update
    # Robot already exists
    if @robot
      attributes_params.each do |attribute_params|
        attribute = @robot.robot_attributes.find_or_initialize_by(key: attribute_params[:key])
        attribute.value = attribute_params[:value]
        attribute.save
      end
    # Robot does not exist
    else
      @robot = Robot.create(name: params[:name])
      @robot.robot_attributes.create(attributes_params)
    end
    render 'show.json.jbuilder'
  end

  # GET /robots/name/history
  def history
    if @robot
      attributes = @robot.robot_attributes.index_by(&:id)
      robot_audits = @robot.associated_audits.order(:created_at)
      @robot_history = {}

      robot_audits.each do |audit|
        value_old = audit.old_attributes['value']
        value_new = audit.new_attributes['value']
        value_old = nil if value_old == value_new
        key = attributes[audit.auditable_id].key
        change_time = audit.created_at.to_formatted_s(:db)
        (@robot_history[change_time] ||= []) << { key: key, value_old: value_old, value_new: value_new }
      end

      render 'history.json.jbuilder'
    else
      render json: { message: 'Robot not found' }, status: 404
    end
  end

  private

  def set_robot
    @robot = Robot.find_by(name: params[:name])
  end

  def robot_params
    params.require(:robot).permit!.to_h
  end

  def attributes_params
    robot_params.map { |attribute| { key: attribute[0], value: attribute[1] } }
  end
end
