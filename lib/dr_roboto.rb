require 'sinatra/base'
require 'active_record'
require 'sinatra/activerecord'

# Load env file configurations
require 'dotenv'
Dotenv.load ".env.#{ENV['RACK_ENV']}"

# Establish database connection
ActiveRecord::Base.establish_connection(
  adapter: ENV['DR_ROBOTO_DB_ENGINE'],
  host: ENV['DR_ROBOTO_DB_HOST'],
  username: ENV['DR_ROBOTO_DB_USER'],
  password: ENV['DR_ROBOTO_DB_PASS'],
  database: ENV['DR_ROBOTO_DB_NAME'],
  encoding: ENV['DR_ROBOTO_DB_ENCODING'] || 'utf8'
)

require 'dr_roboto/version'
require 'dr_roboto/controllers/inspectors_controller'
require 'dr_roboto/controllers/robots_controller'

module DrRoboto
  class App < Sinatra::Base

    configure :development do
      set :show_exceptions, false
    end

    use InspectorsController
    use RobotsController

  end
end
