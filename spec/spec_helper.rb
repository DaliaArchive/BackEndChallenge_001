ENV['RACK_ENV'] = 'test'

require 'sinatra'
require 'active_record'
require 'rspec'
require 'rack/test'
require 'database_cleaner'
require 'json'

require './robot.rb'
require './robolandia.rb'

# setup test environment
set :run, false
set :raise_errors, true
set :logging, false

def app
  Robolandia
end

RSpec.configure do |config|  
  config.include Rack::Test::Methods

  # database_cleaner config
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
  
end