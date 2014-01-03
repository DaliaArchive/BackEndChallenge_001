require_relative "spec_helper"
require_relative "../app/robot"



describe Robot do
  let(:robot) { {"name" => "Hal", "age" => "1500 100 900"} }
  
  describe "#save" do
    
    it "should check if robot is already in db" do
      Robot.store.should_receive(:find_by_name)
      Robot.save(robot)
    end

    context "robot already was at maintenance" do
      it "should update robot entries" do
        Robot.save(robot)
        Robot.find("Hal")["name"].should == "Hal"
      end
      
      it "should maintain change"
    end

    context "no such robot in db" do
      it "should create a new robot entry" do 
        Robot.save(robot)
      end
      
      it "should init maintenance tracking"
    end

    context "last_update should be modified for each update operation" do
      it "should add last_update to each robot" do
        Robot.save(robot)
        Robot.find("Hal")["last_update"].should_not be_nil
      end
    end
  end
  
  describe "#find" do
    context "robot with particular id exists" do 
      
      it "should return a hash with robot data" do
        Robot.save(robot)
        Robot.find("Hal")["age"].should == "1500 100 900"
      end
    end
    
    context "robot with particular id was not found in store" do
      it "should return empty hash" do
        Robot.find("R2D2").should == {}
      end
    end
  end
end
  