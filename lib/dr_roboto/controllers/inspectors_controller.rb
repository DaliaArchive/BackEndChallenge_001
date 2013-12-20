require 'dr_roboto/controllers/base_controller'
require 'dr_roboto/models/inspector'

module DrRoboto
  class InspectorsController < BaseController

    post '/inspectors' do
      raise ParamsMissing unless params[:username].present? && params[:password].present?
      inspector = Inspector.create!(filter_select(params, :username, :password))
      status 201
      cookies[:token] = inspector.token
      { data: 'success' }.to_json
    end

    post '/inspectors/login' do
      raise NotAuthorized unless params[:username].present? && params[:password].present?
      raise NotAuthorized unless inspector = Inspector.find_by(filter_select(params, :username, :password))
      status 200
      cookies[:token] = inspector.token
      { data: 'success' }.to_json
    end

  end
end