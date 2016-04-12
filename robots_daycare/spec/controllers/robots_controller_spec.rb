require 'rails_helper'

RSpec.describe RobotsController, :type => :controller do

  before :each do
    request.env["HTTP_ACCEPT"] = 'application/json'
  end

  let(:valid_attributes) {
    { name: "XXX1" }
  }

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        {
          size: "100cm",
          weight: "10kg",
          color: "black"
        }
      }

      it "updates the requested robot" do
        robot = Robot.find_or_create_by(valid_attributes)
        put :update, {:id => robot.name, :attribs => new_attributes}
        robot.reload
        expect(assigns(:robot)).to eq(robot)
      end
    end
  end
  
  
  describe "GET index" do
    it "assigns all robots as @robots" do
      robot = Robot.find_or_create_by(valid_attributes)
      get :index, {}
      expect(assigns(:robots)).to eq([robot])
    end
  end
  
  describe "GET show" do
    it "assigns the requested robot as @robot" do
      robot = Robot.find_or_create_by(valid_attributes)
      get :show, {:id => robot.name}
      expect(assigns(:robot)).to eq(robot)
    end
  end

end
