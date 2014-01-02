require 'rubygems'
require 'rack/test'

RSpec.configure do |config|
  config.before(:each) do
    ENV["RACK_ENV"] = "test"
  end
  
  config.include Rack::Test::Methods
end

def app
  App
end