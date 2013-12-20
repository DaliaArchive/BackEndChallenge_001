ENV['RACK_ENV'] = 'test'

require 'dr_roboto'
require 'rack/test'
require 'rspec'
require 'database_cleaner'

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

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end
end