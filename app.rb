require 'rubygems'
require 'bundler'

Bundler.require
$: << File.expand_path('../', __FILE__)
$: << File.expand_path('../lib', __FILE__)

module DrRoboto
  class App < Sinatra::Application

    get '/test' do
      "hello world"
    end

  end
end