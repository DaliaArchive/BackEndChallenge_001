require_relative 'spec_helper'
require_relative '../app/app'

require 'awesome_print'

describe App do
  context "get /" do
    it "should greet user" do
      get "/"
      last_response.should be_ok
    end
  end
  
  context "post /robots" do
    it "should add/update robot to db" do
      post '/robots/', {"name" => "Hal", "age" => "3"}.to_json, as_json
      Robot.find("Hal")["age"].should == "3"
      last_response.should be_ok
    end
  end
  
  context "get /robots/:name" do 
    it "should pass robot info" do
      Robot.create!("name" =>"Hal", "age" => "123").save
      get '/robots/Hal'
      last_response.body.should include("123")
      last_response.should be_ok
    end
    
    it "should not pass db id" do
      Robot.create!("name" =>"Hal", "age" => "123").save
      get '/robots/Hal'
      last_response.body.should_not include("BSON")
    end
  end
end

def as_json
  {'Content-Type' => 'application/json'}
end