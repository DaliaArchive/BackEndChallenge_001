class RobotsController < ApplicationController
  include ActionController::MimeResponds # required for respond_to

  def index
    robots = Robot.only([:name, :last_update])

    respond_to do |format|
      if robots != []
        # mongoid doesn't allow for a combination of "only" and "without", so the "_id" field should be removed here
        format.json { render :json => robots.to_json(:except => :_id), status: 200 }
      else
        format.json { render :json => { message: "No robots exist in the database!" } }
      end
    end
  end

  def show
    robot = Robot.find_by(name: params[:name])

    respond_to do |format|
      if robot
        format.json { render :json => robot.to_json(:except => [:_id, :last_update]), status: 200 }
      else
        format.json { render :json => { error_message: "No robot with name #{params[:name]} exists in the database!" }, status: 404 }
      end
    end
  end

  def update
    robot_name = params[:name]
    robot = Robot.find_by(name: robot_name)

    if robot
      # if a robot with the given name exists in the database clone its current attributes
      old_attributes = robot.attributes.clone
      new_attributes = params.except(:action, :controller).merge(last_update: DateTime.now)
      respond_to do |format|
        # and update them with the new values passed in the request
        if robot.update_attributes(params.except(:action, :controller).merge(last_update: DateTime.now))
          format.json { render :json => { success_message: "Robot with name #{params[:name]} succesfully updated!" }, status: 200 }
          # finally, track this update action and the cloned attributes
          track_action(robot_name, 'update', old_attributes, params.except(:action, :controller) )
        else
          format.json { render :json => robot.errors.to_json, error_message: "Robot with name #{params[:name]} could not be updated", status: 400 }
        end
      end
    else
      # if such a robot does not exist in the database create one with all the attributes passed in the request
      robot = Robot.create(params.except(:action, :controller))
      # and track this create action (passing nil for the old_attributes feels wrong but it saves me from ugly-looking code on line 71)
      track_action(robot_name, 'create', nil, params.except(:action, :controller))
      respond_to do |format|
        format.json { render :json => { success_message: "A robot with name #{params[:name]} was inserted in database!" }, status: 200 }
      end
    end
  end

  def history
    robot = Robot.find_by(name: params[:name])

    respond_to do |format|
      if robot
        robot_history = History.where(robot_id: robot.id)
        format.json { render :json => robot_history.to_json(:except => [:_id, :robot_id]), status: 200 }
      else
        format.json { render :json => { error_message: "No robot with name #{params[:name]} exists in the database!" }, status: 404  }
      end
    end
  end

  private

    def track_action(robot_name, action, old_attributes, new_attributes)
      updated_attributes = {}
      if action == 'update'
        # if track_action was called after an update, check which attribute's values are different to the old ones and only keep track of those
        new_attributes.each { |key, value| updated_attributes[key] = "[#{old_attributes[key]}] -> [#{value.to_s}]" unless old_attributes[key] == value }
      else
        # if it was called after a create, all attributes are new so keep track of every single one
        new_attributes.each { |key, value| updated_attributes[key] = "[] -> [#{value.to_s}]" }
      end
      robot = Robot.find_by(name: robot_name)
      # finally, create a history for the updated or created robot along with its modified (or new) attributes
      History.create(robot_id: robot.id, type: action, changes: updated_attributes)
    end

end
