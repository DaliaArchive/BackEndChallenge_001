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

  context "update", :type => :api, :versioning => true do

    context "existing robot", :type => :api do

      before do
        @robot = Robot.create(data: { :weight => 100, :color => "black", :status => "working" })
      end

      it "updates existing attributes" do
        patch "/api/v1/robots/#{@robot.id}", :robot => { data: { :weight => 200, :color => "blue" } }

        @robot.reload
        @robot.data["weight"].to_i.should eql(200)
      end

      it "creates new attributes if they do not exist" do
        patch "/api/v1/robots/#{@robot.id}", :robot => { data: { :weight => 200, :color => "blue", :material => "aluminum" } }

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

  context "index", :type => :api do
    before do
      @robot_1 = Fabricate(:robot, data: { :weight => 100, :color => "black", :status => "working" } )
      @robot_2 = Fabricate(:robot, data: { :weight => 200, :color => "yellow", :status => "working" } )
    end

    it "returns all robots" do
      get "/api/v1/robots"
      Robot.all.should eq([@robot_1, @robot_2])
    end
  end

  context "history", :type => :api, :versioning => true do
    it "returns the attribute changes for a robot" do
      @robot = Robot.create(data: { :weight => 100, :color => "black", :status => "working" })
      @robot.update_attributes(data:{"color" => "yellow"})

      get "/api/v1/robots/#{@robot.id}/history"
      @json_response = JSON.parse(last_response.body)
      @json_response[0]["item_id"].should eq(@robot.id)
    end
  end
end