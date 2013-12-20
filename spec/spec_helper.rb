ENV['RACK_ENV'] = 'test'

require 'dr_roboto'
require 'rspec'
require 'rack/test'

module RSpecMixin
  include Rack::Test::Methods
  def app() 
    DrRoboto::App 
  end
end

RSpec.configure do |config| 
  config.include RSpecMixin

  config.mock_with :rspec
  config.order = "random"
end