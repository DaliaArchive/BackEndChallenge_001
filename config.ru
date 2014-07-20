ENV['RACK_ENV'] = 'production'

require 'rubygems'
require 'bundler'

Bundler.require
require './robot.rb'
require './robolandia.rb'

run Robolandia