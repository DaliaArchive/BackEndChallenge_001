require 'sinatra'
require 'json'


class PublicApp < Sinatra::Base
  get '/' do 
    "Hello Daliaresearch"
  end
end
