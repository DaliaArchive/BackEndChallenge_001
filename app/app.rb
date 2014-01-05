require 'sinatra'
require 'json'
require_relative 'robot'

class App < Sinatra::Base
  
  get '/' do 
    "Hello Daliaresearch"
  end

  post '/robots/?' do
    robot = Robot.create!(JSON.parse(request.body.read))
    robot.save.to_json
  end

  put '/robots/?' do
    robot = Robot.create!(JSON.parse(request.body.read))
    robot.save.to_json
  end
  
  get '/robots/:name' do
    Robot.find(params[:name]).to_json
  end
  


end