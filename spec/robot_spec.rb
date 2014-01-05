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
      robot1 = Robot.create!(robot)
      robot1.save
    end


    context "no such robot in db" do
      it "should create a new robot entry and return status ok" do 
        robot1 = Robot.create!(robot)
        robot1.save.should include "status" => "ok"
      end
      
      it "should init maintenance tracking"
    end

    context "robot already was at maintenance" do
      let(:robot_updated) { {"name" => "Hal", "age" => "13"} }
      it "should update robot entries" do
        robot1 = Robot.create!(robot)
        robot1.save
        robot2 = Robot.create!(robot_updated)      
        robot2.save
        Robot.store.find_by_name("Hal").should include "age" => "13"
      end
      
      it "should return update status ok" do
        robot1 = Robot.create!(robot)
        robot1.save
        robot2 = Robot.create!(robot_updated)      
        robot2.save.should include "status" => "ok"
      end
      
      it "should maintain change"
    end

    context "last_update should be modified for each update operation" do
      it "should add last_update to each robot" do
        robot1 = Robot.create!(robot)
        robot1.save
        Robot.store.find_by_name("Hal")["last_update"].should_not be_nil
      end
    end
  end
  
  describe "#find" do
    context "robot with particular id exists" do 
      
      it "should return a hash with robot data" do
        robot1 = Robot.create!(robot)
        robot1.save
        Robot.find("Hal")["age"].should == "1500 100 900"
      end
    end
    
    context "robot with particular id was not found in store" do
      it "should return empty hash" do
        Robot.find("R2D2").should == nil
      end
    end
  end
end
  