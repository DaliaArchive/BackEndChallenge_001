require 'dr_roboto/controllers/base_controller'
require 'dr_roboto/models/inspector'

module DrRoboto
  class InspectorsController < BaseController

    post '/inspectors' do
      raise ParamsMissing unless params[:username].present? && params[:password].present?
      inspector = Inspector.create!(slice(params, :username, :password))
      status 201
      headers 'SetCookie' => "token=#{inspector.token}"
      { data: 'success' }.to_json
    end

    post '/inspectors/login' do
      raise NotAuthorized unless params[:username].present? && params[:password].present?
      raise NotAuthorized unless inspector = Inspector.where(slice(params, :username, :password)).first
      status 200
      headers 'SetCookie' => "token=#{inspector.token}"
      { data: 'success' }.to_json
    end

  end
end