require 'sinatra'
require 'active_record'

require 'dotenv'
Dotenv.load

require 'dr_roboto/version'
require 'dr_roboto/controllers/inspectors_controller'
require 'dr_roboto/controllers/robots_controller'

module DrRoboto
  class App < Sinatra::Application

    configure do
      ActiveRecord::Base.establish_connection(
        adapter: ENV['DR_ROBOTO_DB_ENGINE'],
        host: ENV['DR_ROBOTO_DB_HOST'],
        username: ENV['DR_ROBOTO_DB_USER'],
        password: ENV['DR_ROBOTO_DB_PASS'],
        database: ENV['DR_ROBOTO_DB_NAME'],
        encoding: 'utf8'
      )
    end

    get '/test' do
      "hello world"
    end

  end
end
