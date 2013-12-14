class RobotsController < ApplicationController

  def create_or_update
    existing_robot = Robot.where(:id => params[:robot][:id]).first
    if(existing_robot.nil?)
      existing_robot = Robot.create(params[:robot])
      audit_changes(:create, nil, params[:robot], existing_robot.id)
    else
      existing_attributes =  existing_robot.attributes.clone
      existing_robot.update_attributes(params[:robot])
      audit_changes(:update, existing_attributes, params[:robot], existing_robot.id)
    end
    render :status => 200, :json => {:robot => existing_robot}
  end

  def show
    robot = Robot.where(:id => params[:id]).first
    return render :status => 400 , :json => { :error_message => "Robot with id:#{params[:id]} does not exist" } if robot.nil?
    render :status => 200, :json => {:robot => robot}
  end

  def index
    render :status => 200, :json => {:robots => Robot.all}
  end

  def history
    robot_audit_trail = RobotAudit.where(:robot_id => params[:id])
    render :status => 200, :json => {:audit => robot_audit_trail.collect { |item| item } }
  end

  private

  def audit_changes(command, original_attributes, changed_attributes, robot_id)
    changes = {}
    changed_attributes_without_id = changed_attributes.reject { |key| key == 'id' }
    if original_attributes.nil?
      changed_attributes_without_id.each { |key,value| changes[key] = "[] -> [ #{value.to_s} ]" }
    else
      changed_attributes_without_id.each { |key,value| changes[key] = "[#{original_attributes[key]}] -> [ #{value.to_s} ]" if original_attributes[key] != value }
    end
    RobotAudit.create(:robot_id => robot_id, :type => command, :changed_attribute_values => changes)
  end

end
