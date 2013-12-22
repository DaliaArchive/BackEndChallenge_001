require 'spec_helper'

describe RobotsController do
  before(:each) do
    Mongoid.raise_not_found_error = false # enables dynamic find method
    request.env["HTTP_ACCEPT"] = "application/json"
  end

  describe "INDEX" do
    it "renders a json object with an appropriate message if no robots exist" do
      get :index
      JSON.parse(response.body)["message"].should eq("No robots exist in the database!")
    end

    it "renders a json object and responds with a status code 200 if robots exist" do
      robot = Robot.create
      robots = Robot.only([:name, :last_update])
      get :index
      response.body.should eq(robots.to_json(:except => :_id))
      response.status.should eq(200)
    end
  end

  describe "SHOW" do
    before(:each) do
      @robot = Robot.create(name: "Daliabot")
    end

    it "renders a json object with an error message and a status code 404 if no robot with the given name exists" do
      get :show, name: "Nobot"
      JSON.parse(response.body)["error_message"].should eq("No robot with name Nobot exists in the database!")
      response.status.should eq(404)
    end

    it "renders a json object with the robot's attributes and responds with a status code 200 if it exists" do
      get :show, name: "Daliabot"
      response.body.should eq(@robot.to_json(:except => [:_id, :last_update]))
      response.status.should eq(200)
    end
  end
  
  describe "UPDATE" do
    before(:each) do
      @robot = Robot.create(name: "Daliabot")
    end

    context "no robot exists with the given name" do
      it "creates a new robot, renders a json object with a success message and a status code 200 and tracks this action" do
        put :update, name: "Newbot", color: "white"
        JSON.parse(response.body)["success_message"].should eq("A robot with name Newbot was inserted in database!")
        response.status.should eq(200)
        robot = Robot.find_by(name: "Newbot")
        History.where(robot_id: robot.id).count.should eq(1)
      end
    end

    context "a robot with the given name exists" do
      it "updates the robot's attributes, renders a json object with an appropriate message and a status code 200 and tracks this action" do
        put :update, name: "Daliabot", color: "red"
        JSON.parse(response.body)["success_message"].should eq("Robot with name Daliabot succesfully updated!")
        response.status.should eq(200)
        robot = Robot.find_by(name: "Daliabot")
        History.where(robot_id: robot.id).count.should eq(1)        
      end
    end
  end

  describe "HISTORY" do
    before(:each) do
      @robot = Robot.create(name: "Daliabot")
    end

    it "renders a json object with an error message and a status code 400 if no robot with the given name exists" do
      get :history, name: "Nobot"
      JSON.parse(response.body)["error_message"].should eq("No robot with name Nobot exists in the database!")
      response.status.should eq(404)
    end

    it "renders a json object with the robot history and a status code 200 if a robot with the given name exists" do
      get :history, name: "Daliabot"
      robot_history = History.where(robot_id: @robot.id)
      response.body.should eq(robot_history.to_json(:except => [:_id, :robot_id]))
      response.status.should eq(200)
    end
  end

end
