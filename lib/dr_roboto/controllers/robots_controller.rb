require 'dr_roboto/controllers/base_controller'
require 'dr_roboto/models/inspector'
require 'dr_roboto/models/robot'
require 'dr_roboto/models/robot_attribute'
require 'dr_roboto/helpers/auth_helper'

module DrRoboto
  class RobotsController < BaseController

    helpers AuthHelper

    before do
      authenticate!
    end

    post '/robots' do
      raise ParamsMissing unless params[:name].present?
      robot = Robot.first_or_create!(name: params[:name])
      RobotAttribute.transaction do
        filter_reject(params, :name).each do |name, value|
          RobotAttribute.where(robot: robot, name: name).first_or_initialize.tap do |a|
            a.value = value
            a.save!
          end
        end
      end
      status 201
      { data: "success" }
    end
    
  end
end