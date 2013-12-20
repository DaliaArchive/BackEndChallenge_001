require 'dr_roboto/controllers/base_controller'
require 'dr_roboto/models/inspector'
require 'dr_roboto/errors/params_missing'

module DrRoboto
  class InspectorsController < BaseController

    post '/inspectors' do
      raise ParamsMissing unless params[:username].present? && params[:password].present?
      inspector = Inspector.create!(slice(params, :username, :password))
      status 201
      headers 'SetCookie' => "token=#{inspector.token}"
      { data: 'success' }.to_json
    end

  end
end