require 'sinatra'
require 'json'
require_relative 'robot'

class App < Sinatra::Base
  
  store = RobotStore.new
  
  get '/' do 
    "Hello Daliaresearch"
  end

  post '/robots/?' do
    Robot.save(JSON.parse(request.body.read))
  end

  put '/robots/?' do
    Robot.save(JSON.parse(request.body.read))
  end


end