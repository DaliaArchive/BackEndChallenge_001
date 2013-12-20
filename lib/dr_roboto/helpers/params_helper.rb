# require 'sinatra/base'

module DrRoboto
  module ParamsHelper
    
    def slice(params, *keys)
      params.select{ |k, v| keys.include?(k.to_sym) }
    end

  end
end