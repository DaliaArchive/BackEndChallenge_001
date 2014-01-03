require_relative '../spec_helper'
require_relative '../../lib/robot_store'


describe RobotStore do
  let(:robot) { {name: "Hal"} }
  let(:robot2) { {name: "Hal2"} }
  
  let(:robot_store) { RobotStore.new }

  context "#create" do
    it "should return the new id" do
      robot_store.create(robot).should_not be_nil
    end
    
    it "should return different ids every time" do
      first_id = robot_store.create(robot)
      second_id = robot_store.create(robot2)
      first_id.should_not == second_id
    end
  end
  
  context "#update" do
    it "should add new k/v pairs to entry" do
      id = robot_store.create(robot)
      robot_store.update(id, {"iq" => 1234})
      robot_store.find(id)["iq"].should == 1234
    end
    
    it "should overwrite values if updated" do
      id = robot_store.create(robot)
      robot_store.update(id, {"name" => "Hal 9000"})
      robot_store.find(id)["name"].should == "Hal 9000"
    end
    
    it "should leave not touched values in initial state" do
      id = robot_store.create(robot)
      robot_store.update(id, {"friend_of" => "Frank Poole"})
      robot_store.find(id)["name"].should == "Hal"
    end
  end
  
  context "#find" do
    it "should return a robot hash if found" do
      id = robot_store.create(robot)
      robot_store.find(id).should == {"name" => "Hal", "_id" => id}
    end
    
    it "should return nil if no robot found" do
      id = robot_store.create(robot)
      string_id = id.to_s
      invalid_id = string_id[-1] == 0 ? string_id[0..-2] << "1" : string_id[0..-2] << "0"
      robot_store.find(BSON::ObjectId.from_string(invalid_id)).should be_nil
    end
  end
  
  context "#find_by_name" do
    let(:robot) { {name: "R2D2"} }
    
    it "should return a robot hash if found" do
      id = robot_store.create(robot)
      robot_store.find_by_name("R2D2").should == {"name" => "R2D2", "_id" => id}
    end
    
    it "should return nil if no robot found" do
      id = robot_store.create(robot)
      robot_store.find_by_name("Halifax").should be_nil
    end
  end
end