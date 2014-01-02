require 'sinatra'

class App < Sinatra::Base
  
  get '/' do 
    "Hello Daliaresearch"
  end

end