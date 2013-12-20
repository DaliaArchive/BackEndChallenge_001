require 'sinatra/base'
require 'sinatra/cookies'
require 'json'
require 'dr_roboto/models/inspector'
require 'dr_roboto/models/robot'
require 'dr_roboto/models/robot_attribute'
require 'dr_roboto/helpers/params_helper'
require 'dr_roboto/helpers/auth_helper'
require 'dr_roboto/errors/params_missing'
require 'dr_roboto/errors/not_authorized'
require 'dr_roboto/errors/not_found'

module DrRoboto
  class BaseController < Sinatra::Base

    helpers Sinatra::Cookies
    helpers ParamsHelper

    before do
      content_type :json
    end

    error NotAuthorized do
      status 401
      { error: 'not_authorized' }.to_json
    end

    error ParamsMissing, ActiveRecord::RecordInvalid do
      status 400
      { error: 'invalid_parameters' }.to_json
    end

    error NotFound, ActiveRecord::RecordNotFound do
      status 404
      { error: 'not_found' }.to_json
    end

  end
end