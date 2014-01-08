require 'rubygems'
require './app/app'
require './app/public_app'


run Rack::URLMap.new("/" => PublicApp.new, "/api_v1" => App.new)
