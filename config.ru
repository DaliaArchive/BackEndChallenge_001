require 'rubygems'
require './app/app'


run Rack::URLMap.new("/" => App.new)
