require 'sinatra/base'
require 'yaml'

class Robolandia < Sinatra::Base      
  
  before do
    content_type 'application/json'
  end

  config = YAML.load_file "./auth.yml"
  database = YAML.load_file "db/database.yml"    

  use Rack::Auth::Basic do |username, password|
    [username, password] == [config['user'], config['pass']]
  end
  
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  ActiveRecord::Migration.verbose = true
  ActiveRecord::Base.establish_connection database[settings.environment.to_s]

  Dir.mkdir("log") unless File.exist?("log")
  $log = Logger.new("log/robolandia.log", 'daily')
  $log.level = Logger::DEBUG
  $log.info "#{Time.now.to_s(:db)} Robolandia is now accepting json requests."

  get '/robots.json' do                
    robots = {}
    Robot.all.each { |robot| robots[robot.id] = robot.attrs.merge(last_update: robot.updated_at.to_s) }       
    robots.to_json     
  end

  get '/robots/:id.json' do    
    robot = Robot.find_by_id params['id']    
    return status 404 unless robot
    robot.attrs.to_json  
  end

  put '/robots/:id.json' do            
    return { error: "unsupported format" }.to_json unless request.content_type == "application/json"         
    id = params['id']        
    params = JSON.parse(request.env["rack.input"].read)    
    robot = Robot.find_by_id id
    robot = robot ? robot.update(params) : Robot.create(id, params)    
    robot.to_json 
  end

  get '/robots/:id/history.json' do        
    robot = Robot.find_by_id params[:id]      
    return status 404 unless robot
    robot.get_history.to_json  
  end

end
