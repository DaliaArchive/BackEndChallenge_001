require 'spec_helper'

describe "/api/v1/robots" do


  context "show", :type => :api  do
    before do
      @robot = Fabricate(:robot)
    end
    let(:url) { "/api/v1/robots/#{@robot.id}" }


    it "JSON" do
      get "#{url}"   
      @json_response = JSON.parse(last_response.body)
      @json_response["id"].should eql(@robot.id)
      last_response.status.should eql(200)
    end
  end

  context "update", :type => :api do

    context "existing robot", :type => :api do

      before do
        @robot = Fabricate(:robot, weight: 100, color: "black", status: "working")
      end

      it "updates existing attributes" do
        patch "/api/v1/robots/#{@robot.id}", :robot => { weight: 200, color: "blue"}

        @robot.reload
        @robot.weight.should eql(200)
      end

      it "creates new attributes if they do not exist" do
        patch "/api/v1/robots/#{@robot.id}", :robot => { weight: 200, color: "blue", material: "aluminum"}

        @robot.reload
        @robot.material.should be_present
        @robot.material.should eql("aluminum")
      end

    end

    context "non-existing robot", :type => :api do
      it "creates a new robot" do
        patch "/api/v1/robots/1" , :robot => { weight: 200, color: "blue"}

        Robot.first.should be_present
      end
    end
  end
end