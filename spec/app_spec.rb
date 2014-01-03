require_relative 'spec_helper'
require_relative '../app/app'

describe App do
  context "get /" do
    it "should greet user" do
      get "/"
      last_response.should be_ok
    end
  end
  
  context "put /robots" do
    it "should add/update robot to db" do
      post '/robots/', {"name" => "Hal", "age" => "3"}.to_json, as_json
      Robot.find("Hal")["age"].should == "3"
    end
    
  end
end

def as_json
  {'Content-Type' => 'application/json'}
end