require 'sinatra/base'
require 'sinatra/cookies'
require 'json'
require 'dr_roboto/helpers/params_helper'
require 'dr_roboto/errors/params_missing'

module DrRoboto
  class BaseController < Sinatra::Base

    # helpers Sinatra::Cookies
    helpers ParamsHelper

    before do
      content_type :json
    end

    error ParamsMissing do
      status 400
      { error: 'invalid_parameters' }.to_json
    end

    error ActiveRecord::RecordInvalid do
      status 400
      { error: 'invalid_parameters' }.to_json
    end

  end
end