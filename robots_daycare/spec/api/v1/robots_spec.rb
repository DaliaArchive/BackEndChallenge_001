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
        @robot = Fabricate(:robot, data: { weight: 100, color: "black", status: "working" } )
      end

      it "updates existing attributes" do
        patch "/api/v1/robots/#{@robot.id}", :robot => { data: { weight: 200, color: "blue" } }

        @robot.reload
        @robot.data["weight"].to_i.should eql(200)
      end

      it "creates new attributes if they do not exist" do
        patch "/api/v1/robots/#{@robot.id}", :robot => { data: {weight: 200, color: "blue", material: "aluminum" } }

        @robot.reload
        @robot.data["material"].should be_present
        @robot.data["material"].should eql("aluminum")
      end

    end

    context "non-existing robot", :type => :api do
      it "creates a new robot" do
        patch "/api/v1/robots/1" , :robot => { data: { weight: 200, color: "yellow"} }

        Robot.first.should be_present
        Robot.first.data["color"].should eql("yellow")
      end
    end
  end

  context "history", :type => :api do
  end
end