require 'spec_helper'

describe DrRoboto::RobotsController do

  describe "GET /robotos" do

  end

  describe "POST /robots" do

    context "when a valid token is passed" do
      let(:inspector) { Inspector.first_or_create(username: 'inspector_gadget', password: '1234') }
      let(:new_attributes) { {weight: '10kg', age: '20'} }

      context "if the name parameter is included with the request" do

        context "and the robot's name exists in the database" do
          before do
            @robot = Robot.first_or_create(name: 'robot1')
            post "/robots", { name: 'robot1'}.merge(new_attributes), { 'Cookie' => "token=#{inspector.token}" }
          end
          subject { last_response }
          let(:robot) { @robot }
          it { subject.status.should == 201 }
          it "should create or update the robot's attributes" do
            new_attributes.should each { |k, v| Attribute.where(robot: robot, key: k, value: v) }
          end
        end

        context "and the robot's name is not registered in the database" do
          before do
            Robot.where(name: 'robot1').destroy_all
            post "/robots", { name: 'robot1'}.merge(new_attributes), { 'Cookie' => "token=#{inspector.token}" }
          end
          subject { last_response }
          let(:robot) { Robot.where(name: 'robot1').first }
          it { robot.present?.should == true }
          it { subject.status.should == 201 }
          it "should create the attributes" do
            new_attributes.should each { |k, v| Attribute.where(robot: robot, key: k, value: v).exists?.should == true }
          end
        end

      end

      context "if the name parameter is not present" do
        before do
          post "/robots", new_attributes, { 'Cookie' => "token=#{inspector.token}" }
        end
        subject { last_response }
        it { subject.status.should == 400 }
      end

    end

    context "when a missing or invalid token is passed" do
      before do
        post "/robots", { some_attr: 'some_value' }, { 'Cookie' => 'token=invalid_token' }
      end
      subject { last_response }
      it { subject.status.should == 401 }
      it { subject.body.should == { error: 'not_authorized' }.to_json }
    end

  end

end