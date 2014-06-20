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

    context "when the robots database is empty" do
      before do
        DrRoboto::Robot.destroy_all
        set_cookie "token=#{inspector.token}"
        get "/robots"
      end
      subject { last_response }
      it { subject.status.should == 200 }
      it { subject.content_type.should == 'application/json;charset=utf-8' }
      it { JSON.parse(subject.body).key?('data').should == true }
      it { JSON.parse(subject.body)['data'].size.should == 0 }
    end

  end

  describe "GET /robots/:name" do

    let(:inspector) { DrRoboto::Inspector.where(username: 'inspector_gadget', password: '1234').first_or_create }
    let(:new_attributes) { {'weight' => '10kg', 'age' => '20'} }

    context "when the robot is found" do
      before do
        robot = DrRoboto::Robot.where(name: 'robot1').first_or_create
        robot.robot_attributes.destroy_all
        new_attributes.each do |k, v|
          DrRoboto::RobotAttribute.create(robot: robot, name: k, value: v)
        end
        set_cookie "token=#{inspector.token}"
        get "/robots/robot1"
      end
      subject { last_response }
      it { subject.status.should == 200 }
      it { subject.content_type.should == 'application/json;charset=utf-8' }
      it { JSON.parse(subject.body).key?('data').should == true }
      it { JSON.parse(subject.body)['data'].should == { 'name' => 'robot1' }.merge(new_attributes) }
    end

    context "when the robot is not found" do
      before do
        DrRoboto::Robot.where(name: 'robot1').destroy_all
        set_cookie "token=#{inspector.token}"
        get "/robots/robot1"
      end
      subject { last_response }
      it { subject.status.should == 404 }
      it { subject.content_type.should == 'application/json;charset=utf-8' }
      it { subject.body.should == { error: 'not_found' }.to_json }
    end

  end

  describe "GET /robots/:name/history" do

    let(:inspector) { DrRoboto::Inspector.where(username: 'inspector_gadget', password: '1234').first_or_create }
    let(:first_attributes){ {'age' => '10', 'size' => '15'} }
    let(:second_attributes){ {'age' => '15', 'weight' => '200'} }
    let(:third_attributes){ {'age' => '20', 'size' => '120'} }

    context "when the robot's attributes have no previous versions" do
      before do
        PaperTrail.enabled = true
        DrRoboto::Robot.where(name: 'robot1').destroy_all
        robot = DrRoboto::Robot.create(name: 'robot1')
        first_attributes.each do |k, v|
          DrRoboto::RobotAttribute.create(robot: robot, name: k, value: v)
        end
        set_cookie "token=#{inspector.token}"
        get "/robots/robot1/history"
      end
      subject { last_response }
      let(:result) do
        {
          'age' => [
            { 'event' => 'create', 'value' => nil }
          ],
          'size' => [
            { 'event' => 'create', 'value' => nil }
          ]
        }
      end
      it { subject.status.should == 200 }
      it { subject.content_type.should == 'application/json;charset=utf-8' }
      it { JSON.parse(subject.body).key?('data').should == true }
      it "should deliver the expected results (+/- the changed_at dates)" do
        data = JSON.parse(subject.body)['data']
        data_without_changed_at = {}
        data.each do |a, changes|
          data_without_changed_at[a] = changes.map do |change|
            change.reject{ |k| k == 'changed_at' }
          end
        end
        data_without_changed_at.should == result
      end
    end

    context "when the robot's attributes have changed several times" do
      before do
        PaperTrail.enabled = true
        DrRoboto::Robot.where(name: 'robot1').destroy_all
        @robot = DrRoboto::Robot.create(name: 'robot1')
        DrRoboto::RobotAttribute.update_or_create_from_hash(@robot, first_attributes)
        DrRoboto::RobotAttribute.update_or_create_from_hash(@robot, second_attributes)
        DrRoboto::RobotAttribute.update_or_create_from_hash(@robot, third_attributes)
        set_cookie "token=#{inspector.token}"
        get "/robots/robot1/history"
      end
      subject { last_response }
      let(:result) do
        { 
          'age' => [
            { 'event' => 'create', 'value' => nil },
            { 'event' => 'update', 'value' => '10' },
            { 'event' => 'update', 'value' => '15' }
          ],
          'size' => [
            { 'event' => 'create', 'value' => nil },
            { 'event' => 'update', 'value' => '15' }
          ],
          'weight' => [
            { 'event' => 'create', 'value' => nil }
          ]
        }
      end
      it { DrRoboto::RobotAttribute.find_by(robot: @robot, name: 'age').versions.size.should > 0 }
      it { subject.status.should == 200 }
      it { subject.content_type.should == 'application/json;charset=utf-8' }
      it { JSON.parse(subject.body).key?('data').should == true }
      it "should deliver the expected results (+/- the changed_at dates)" do
        data = JSON.parse(subject.body)['data']
        data_without_changed_at = {}
        data.each do |a, changes|
          data_without_changed_at[a] = changes.map do |change|
            change.reject{ |k| k == 'changed_at' }
          end
        end
        data_without_changed_at.should == result
      end
    end

  end

end