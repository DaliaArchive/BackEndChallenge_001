require_relative '../spec_helper'
require_relative '../../lib/robot_store'


describe RobotStore do
  let(:name1) { "Hal" }
  let(:name2) { "R2d2" }
  let(:robot1) { {"name" => name1, "age" => "12"} }
  let(:robot2) { {"name" => name2} }
  
  let(:robot_store) { RobotStore.new }

  context "#create" do
    it "should return status ok" do
      robot_store.create(robot1).should include "status" => "ok"
    end
    
    it "should create new entries each time" do
      robot_store.create(robot1)
      robot_store.create(robot2)
      id1 = robot_store.find_by_name(name1)["_id"]
      id2 = robot_store.find_by_name(name2)["_id"]
      id1.should_not == id2
    end
  end
  
  context "#create_history" do
    let(:history1) { {"name" => name1, "type" => "create"} }
    let(:history2) { {"name" => name2, "type" => "create"} }

    it "should return status ok" do
      robot_store.create_history(history1).should include "status" => "ok"
    end
    
    it "should create new entries each time" do
      robot_store.create_history(history1)
      robot_store.create_history(history2)
      id1 = robot_store.history_by_name(name1).first["_id"]
      id2 = robot_store.history_by_name(name2).first["_id"]
      id1.should_not == id2
    end
  end
  
  
  context "#update" do
    it "should add new k/v pairs to entry" do
      robot_store.create(robot1)
      robot_store.update(name1, {"iq" => 1234})
      robot_store.find_by_name(name1)["iq"].should == 1234
    end
    
    it "should overwrite values if keys updated" do
      robot_store.create(robot1)
      robot_store.update(name1, {"age" => "13"})
      robot_store.find_by_name(name1)["age"].should == "13"
    end
    
    it "should leave values of not changed keys in initial state" do
      robot_store.create(robot1)
      robot_store.update(name1, {"IQ" => "1234"})
      robot_store.find_by_name(name1)["age"].should == "12"
    end
  end
  
  context "#find_by_name" do    
    it "should return a robot hash if found" do
      robot_store.create(robot1)
      robot_store.find_by_name(name1)["age"].should == "12"
    end
    
    it "should return nil if no robot found" do
      id = robot_store.create(robot1)
      robot_store.find_by_name("Halifax").should be_nil
    end
  end
  
  context "#history_by_name" do    
    let(:history1) { {"name" => name1, "type" => "create"} }

    it "should return an array of entries if found" do
      robot_store.create_history(history1)
      robot_store.history_by_name(name1).first["type"].should == "create"
    end
    
    it "should return nil if no robot found" do
      robot_store.history_by_name(name1).should be_nil
    end
  end
end