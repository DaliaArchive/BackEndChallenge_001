require 'spec_helper'

describe DrRoboto::RobotsController do

  before do
    DatabaseCleaner.clean
  end

  describe "POST /robots" do

    context "when a valid token is passed" do
      let(:inspector) { DrRoboto::Inspector.where(username: 'inspector_gadget', password: '1234').first_or_create }
      let(:new_attributes) { {'weight' => '10kg', 'age' => '20'} }

      context "if the name parameter is included with the request" do

        context "and the robot's name exists in the database" do
          before do
            @robot = DrRoboto::Robot.where(name: 'robot1').first_or_create
            set_cookie "token=#{inspector.token}"
            post "/robots", { name: 'robot1'}.merge(new_attributes) #, { 'Cookie' => "token=#{inspector.token}" }
          end
          subject { last_response }
          let(:robot) { @robot }
          it { subject.status.should == 201 }
          it "should create or update the robot's attributes" do
            new_attributes.each do |k, v| 
              DrRoboto::RobotAttribute.where(robot: robot, name: k, value: v).exists?.should == true
            end
          end
        end

        context "and the robot's name is not registered in the database" do
          before do
            DrRoboto::Robot.where(name: 'robot1').destroy_all
            set_cookie "token=#{inspector.token}"
            post "/robots", { name: 'robot1'}.merge(new_attributes)
          end
          subject { last_response }
          let(:robot) { DrRoboto::Robot.where(name: 'robot1').first }
          it { robot.present?.should == true }
          it { subject.status.should == 201 }
          it "should create the attributes" do
            new_attributes.each do |k, v| 
              DrRoboto::RobotAttribute.where(robot: robot, name: k, value: v).exists?.should == true
            end
          end
        end

      end

      context "if the name parameter is not present" do
        before do
          set_cookie "token=#{inspector.token}"
          post "/robots", new_attributes
        end
        subject { last_response }
        it { subject.status.should == 400 }
      end

    end

    context "when a missing or invalid token is passed" do
      before do
        DrRoboto::Inspector.where(token: 'invalid_token').destroy_all
        set_cookie "token=invalid_token"
        post "/robots", { some_attr: 'some_value' }
      end
      subject { last_response }
      it { subject.status.should == 401 }
      it { subject.body.should == { error: 'not_authorized' }.to_json }
    end

  end

  describe "GET /robotos" do

    let(:inspector) { DrRoboto::Inspector.where(username: 'inspector_gadget', password: '1234').first_or_create }

    context "when robots are found in the database" do
      before do
        DrRoboto::Robot.destroy_all
        @robots = (0..9).map{ |i| DrRoboto::Robot.create(name: "robot#{i}") }
        set_cookie "token=#{inspector.token}"
        get "/robots"
      end
      subject { last_response }
      it { subject.status.should == 200 }
      it { subject.content_type.should == 'application/json;charset=utf-8' }
      it { JSON.parse(subject.body).key?('data').should == true }
      it { JSON.parse(subject.body)['data'].size.should == 10 }
    end

  end

end