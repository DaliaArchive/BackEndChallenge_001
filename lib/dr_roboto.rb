require 'sinatra/base'
require 'active_record'
require 'sinatra/activerecord'

# Load env file configurations
# For a list of ENV variables to set in production see .env.development
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

    # Plug in or remove controllers here (e.g. a future DoctorsController)
    use InspectorsController
    use RobotsController

  end
end
