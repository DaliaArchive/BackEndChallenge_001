require 'sinatra'
require 'json'
require_relative 'robot'

class App < Sinatra::Base
  
  use Rack::Auth::Basic do |username, password|
    username == 'foo' && password == 'bar'
  end
  
  post '/robots/?' do
    robot = Robot.create!(JSON.parse(request.body.read))
    robot.save.to_json
  end

  put '/robots/?' do
    robot = Robot.create!(JSON.parse(request.body.read))
    robot.save.to_json
  end
  
  get '/robots/?' do
    Robot.index.to_json
  end
  
  get '/robots/:name/?' do
    Robot.find(params[:name]).to_json
  end
  
  get '/robots/:name/history/?' do
    Robot.find_history(params[:name]).to_json
  end
end

