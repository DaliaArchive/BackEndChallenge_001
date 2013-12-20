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

    get '/robots' do
      robots = Robot.order('updated_at DESC')
      { data: robots }.to_json
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
      { data: "success" }.to_json
    end

    get '/robots/:name' do
      raise ParamsMissing unless params[:name].present?
      robot = Robot.includes(:robot_attributes).find_by!(name: params[:name])
      data = (robot.robot_attributes || []).inject({ name: robot.name }) do |acc, attr| 
        acc.merge(attr.to_hash)
      end
      status 200
      { data: data }.to_json
    end

    get '/robots/:name/history' do

    end
    
  end
end