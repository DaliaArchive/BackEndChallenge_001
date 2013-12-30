require 'spec_helper'

describe "Robolandia app" do   

  let(:headers) { { "CONTENT_TYPE" => "application/json" } }  

  context "for unauthorized inspectors" do 

    it "should respond with a 401 HTTP code" do

      get '/robots.json'          
      last_response.status.should == 401
      
      get '/robots/1.json'
      last_response.status.should == 401
      
      get '/robots/1/history.json'
      last_response.status.should == 401

      request_data = { "name" => "Unauthorized Robot" }      
      put "/robots/1.json", request_data.to_json, headers      
      last_response.status.should == 401
    end

  end

  describe "GET /robots.json" do  

    context "when providing a valid auth" do

      context "and when no robots are available" do
        
        it "should respond with an empty json object" do
          authorize 'inspector', 'g76F&h8'            
          get '/robots.json'
          last_response.should be_ok        
          expect(JSON.parse(last_response.body)).to eq({})
        end    

      end    

      context "and when there are robots available" do 

        it "should respond with a list of all available robots" do
          robot_1 = Robot.create!({ attrs: { "name" => "Robot 1" }, history: nil })
          robot_2 = Robot.create!({ attrs: { "name" => "Robot 2" }, history: nil })
          authorize 'inspector', 'g76F&h8'
          get '/robots.json'
          last_response.should be_ok
          JSON.parse(last_response.body).size.should == 2                
        end

      end

    end

  end

end