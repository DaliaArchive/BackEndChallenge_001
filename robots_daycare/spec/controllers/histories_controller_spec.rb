require 'rails_helper'

RSpec.describe HistoriesController, :type => :controller do

  before :each do
    request.env["HTTP_ACCEPT"] = 'application/json'
    
  end

  let(:valid_attributes) {
    { name: "XXX1",
      attribs: {
          size: "100cm",
          weight: "10kg",
          color: "yellow"
        }
     }
  }

  describe "GET index" do
    it "assigns robots all histories as @robots" do
      robot = Robot.create(valid_attributes)
      get :index, {:robot_id => robot.name}
      expect(assigns(:robot)).to eq(robot)
    end
  end
  

end
