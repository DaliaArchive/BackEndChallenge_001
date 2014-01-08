require_relative "./spec_helper"
require_relative "../app/robot"

describe Robot do
  let(:robot) { {"name" => "Hal", "age" => "1500 100 900"} }
  
  describe "#save" do
    it "should disallow saving robot without name" do
      unnamed_robot = Robot.create!("age" => "1500 100 900")
      unnamed_robot.save.should include "status" => "error"
    end
    
    it "should check if robot is already in db" do
      Robot.store.should_receive(:find_by_name)
      Robot.create!(robot).save
    end


    context "no such robot in db" do
      it "should create a new robot entry and return status ok" do 
        Robot.create!(robot).save.should include "status" => "ok"
      end
      
      it "should init maintenance tracking" do
        Robot.create!(robot).save
        Robot.store.history_by_name("Hal").first.should include "type" => "create"
        Robot.store.history_by_name("Hal").first["log"].should include "name" => "[] -> [Hal]"
      end
    end

    context "robot already was at maintenance" do
      let(:robot_updated) { {"name" => "Hal", "age" => "13"} }
      it "should update robot entries" do
        Robot.create!(robot).save
        Robot.create!(robot_updated).save
        Robot.store.find_by_name("Hal").should include "age" => "13"
      end
      
      it "should return update status ok" do
        Robot.create!(robot).save
        Robot.create!(robot_updated).save.should include "status" => "ok"
      end
      
      it "should maintain change in history" do 
        Robot.create!(robot).save
        Robot.create!(robot_updated).save
        Robot.store.history_by_name("Hal").last.should include "type" => "update"
        Robot.store.history_by_name("Hal").last["log"].should include "age" => "[1500 100 900] -> [13]"
      end

      it "should not list keys for nested hashes with empty values" do 
        robot = {"name"=> "newborn", "date_of_assembly" => {"year" => "2013", "month" => "Dec"}}
        robot_updated = {"name"=> "newborn", "date_of_assembly" => {"year" => "2013", "month" => "Dec"}}
        Robot.create!(robot).save
        Robot.create!(robot_updated).save
        Robot.store.history_by_name("newborn").last["log"].should_not include "date_of_assembly" => "{}"
      end

    end

    context "last_update should be modified for each update operation" do
      it "should add last_update to each robot" do
        Robot.create!(robot).save
        Robot.store.find_by_name("Hal")["last_update"].should_not be_nil
      end
    end
  end
  
  describe "#find" do
    context "robot with particular id exists" do 
      
      it "should return a hash with robot data" do
        Robot.create!(robot).save
        Robot.find("Hal")["age"].should == "1500 100 900"
      end
      
      it "should not propagate internal db id" do
        Robot.create!(robot).save
        Robot.find("Hal")["_id"].should be_nil
      end
    end
    
    context "robot with particular id was not found in store" do
      it "should return empty hash" do
        Robot.find("R2D2").should == nil
      end
    end
  end
  
  describe "#find_history" do
    context "robot with particular id exists" do 
      let(:robot_updated) { {"name" => "Hal", "age" => "13"} }
      
      it "should return a hash with robot data" do
        Robot.create!(robot).save
        Robot.find_history("Hal").first["type"].should == "create"
      end
      
      it "should maintain each change, which affected robot" do
        Robot.create!(robot).save
        Robot.create!(robot_updated).save
        Robot.find_history("Hal").last["log"]["age"].should == "[1500 100 900] -> [13]"        
      end

      it "should not propagate internal db id" do
        Robot.create!(robot).save
        Robot.create!(robot_updated).save
        Robot.find_history("Hal").last["_id"].should be_nil
      end
    end
    
    context "robot with particular id was not found in store" do
      it "should return status ok with info about incident" do
        Robot.find_history("R2D2")["info"].should include "No such robot in database"
      end
    end
  end
  
  describe "#index" do
    let(:robot) { {"name" => "Hal", "last_update" => "a long long time ago" } }
    let(:another_robot) { {"name" => "R2D2"} }

    context "there is at least one robot" do
      it "should return hash containing name -> last update key/value pairs" do
        Robot.create!(robot).save
        Robot.create!(another_robot).save
        result = Robot.index
        result["Hal"].should_not == "a long long time ago" # as save operation modifies last_update
        result["R2D2"].should_not be_nil
      end
    end
     
    context "collection does not contain any robots" do
      it "should pass info, that there are no robots" do
        Robot.index["info"].should include "No robots"
      end
    end
    
  end
end
  