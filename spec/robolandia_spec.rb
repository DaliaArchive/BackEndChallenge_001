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

  describe "GET /robots/:id.json" do  

    context "when providing a valid auth" do 

      context "but an unavailable robot id" do

        it "should return unavailable resource HTTP code" do 
          authorize 'inspector', 'g76F&h8'            
          get '/robots/1.json'
          last_response.status.should == 404
        end

      end

      context "and a existent robot id" do 

        it "should return the robot attributes" do       
          authorize 'inspector', 'g76F&h8'
          robot = Robot.create!({ attrs: { "name" => "API GET ROBOT" }, history: nil })
          get "/robots/#{robot.id}.json"
          last_response.should be_ok        
          expect(JSON.parse(last_response.body)["name"]).to eq("API GET ROBOT")
        end

      end

    end

  end

  describe "PUT /robots/:id.json" do
    
    context "when providing valid auth" do

      context "but passing data with an invalid format (other than JSON)" do 

        it "should respond with" do
          authorize 'inspector', 'g76F&h8'
          put "/robots/1.json"         
          JSON.parse(last_response.body)["error"].should == "unsupported format"
        end

      end

      context "for an existing robot id" do 

        it "should update the existent robots attributes" do          
          authorize 'inspector', 'g76F&h8'     
          robot = Robot.create!({ attrs: { "name" => "API PUT ROBOT" }, history: nil })
          robot.attrs["name"].should == "API PUT ROBOT"          
          request_data = { "name" => "API PUT CHANGE ROBOT", "last" => "Testing" }
          put "/robots/#{robot.id}.json", request_data.to_json, headers
          robot.reload                
          robot.attrs["name"].should == "API PUT CHANGE ROBOT"        
          # test for the returned robot oject
          JSON.parse(last_response.body)["attrs"]["name"].should == "API PUT CHANGE ROBOT"  
        end      

      end

      context "for a nonexistent robot id" do

        it "should create a new robot with the specified attributes" do 
          authorize 'inspector', 'g76F&h8'
          request_data = { "name" => "New robot", "last name" => "new robot last name" }          
          Robot.all.size.should == 0
          put "/robots/1.json", request_data.to_json, headers
          Robot.all.size.should == 1
          JSON.parse(last_response.body)["attrs"]["name"].should == "New robot"
        end

      end

    end

  end

  describe "GET /robots/:id/history.json" do 

    context "when providing valid auth" do

      context "for an existent robot id" do

        it "should return the robot changes history" do 
          authorize 'inspector', 'g76F&h8'         
          robot = Robot.create(1, { "name" => "History Robot" })           
          get "/robots/#{robot.id}/history.json"
          last_response.should be_ok
          expect(JSON.parse(last_response.body)[robot.updated_at.utc.to_s]["type"]).to eq("create")
          expect(JSON.parse(last_response.body)[robot.updated_at.utc.to_s]["changes"]["name"]).to eq("'' to '#{robot.attrs['name']}'")                    
        end

      end

      context "for an invalid robot id" do 

        it "should return unavailable resource http code" do
          authorize 'inspector', 'g76F&h8'            
          get '/robots/1/history.json'
          last_response.status.should == 404
        end      

      end

    end

  end

end