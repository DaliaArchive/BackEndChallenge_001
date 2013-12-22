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

end
